Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab1CDPN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:13:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1CDPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:13:55 -0500
Message-ID: <4D7101AF.6060009@redhat.com>
Date: Fri, 04 Mar 2011 10:13:51 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan>
In-Reply-To: <20110303220155.GB27691@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 05:01 PM, Nikola Ciprich wrote:
>> That sounds like a kernel which will be vulnerable to broken KVM clock
>> on 32-bit.  There's a kernel side fix that is needed, but why the server
>> side change triggers the problem needs more investigation.
>>      
> OK, it's important for me that I can fix this by kernel parameter,
> but if I can help somehow with debugging, please let me know.
> thanks for Your time!
> nik
>    

You don't see any messages about TSC being unstable or switching 
clocksource after loading the KVM module?  And you are not suspending 
the host or anything?

Can you try using "processor.max_cstate=1" on the host as a kernel 
parameter and see if it makes a difference?
