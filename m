Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab1CCV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:58:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263Ab1CCV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:58:45 -0500
Message-ID: <4D700F09.9000002@redhat.com>
Date: Thu, 03 Mar 2011 16:58:33 -0500
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
References: <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com> <20110228152823.GF29840@pcnci.linuxbox.cz> <4D6BC5CA.8060004@redhat.com> <20110228171550.GA2173@nik-comp.lan> <4D6EF536.305@redhat.com> <20110303070652.GG29840@pcnci.linuxbox.cz> <4D6FFE5D.1030401@redhat.com> <20110303210647.GA27691@nik-comp.lan>
In-Reply-To: <20110303210647.GA27691@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 04:06 PM, Nikola Ciprich wrote:
>> What is the exact kernel version you are using in the guest.
>>      
> It's latest centos (2.6.18-194.32.1.el5), so I guess there are a lot
> of fixes, but it's possible the kvm-clock is broken in it.
> I can't influence what kernel is used there (at least not on customer's
> guests), but I guess asking for adding clocksource kernel parameter is
> not problem.
>
>    

That sounds like a kernel which will be vulnerable to broken KVM clock 
on 32-bit.  There's a kernel side fix that is needed, but why the server 
side change triggers the problem needs more investigation.

Zach
