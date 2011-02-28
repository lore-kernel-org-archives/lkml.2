Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1B1Nvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:51:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1B1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:51:29 -0500
Message-ID: <4D6BA85B.7080908@redhat.com>
Date: Mon, 28 Feb 2011 08:51:23 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan>
In-Reply-To: <20110227172052.GB2474@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2011 12:20 PM, Nikola Ciprich wrote:
>> I was not aware of the thread.  Please cc me directly, or add a keyword
>> I track - timekeeping, TSC..
>>      
> Hello Zachary, thanks for Your time looking at this!
>    
>> That change alone may not bisect well; without further fixes on top of
>> it, you may end up with a hang or stall, which is likely to manifest in
>> a vendor-specific way.
>>      
> I'm not sure I really understand You here, but this change is exactly to
> what I got while bisecting. With later revisions, including this one,
> 32bit SMP guests don't boot, before it, they do..
>    

Does the bug you are hitting manifest on both Intel and AMD platforms?

Further, do the systems you are hitting this on have stable or unstable 
TSCs?

Thanks,

Zach
