Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1B1PaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:30:06 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:50250 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab1B1PaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:30:04 -0500
Date: Mon, 28 Feb 2011 16:28:23 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110228152823.GF29840@pcnci.linuxbox.cz>
References: <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz> <20110225104823.GD29840@pcnci.linuxbox.cz> <4D67C077.6060108@redhat.com> <20110227172052.GB2474@nik-comp.lan> <4D6BA85B.7080908@redhat.com> <20110228143247.GE29840@pcnci.linuxbox.cz> <4D6BBC84.6020408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BBC84.6020408@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4673852 records (last update: 20110228)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:17:24AM -0500, Zachary Amsden wrote:
> On 02/28/2011 09:32 AM, Nikola Ciprich wrote:
>>> Does the bug you are hitting manifest on both Intel and AMD platforms?
>>>      
>> I don't have any AMD box here, I'll try this out at my home box.
>>
>>    
>>> Further, do the systems you are hitting this on have stable or unstable
>>> TSCs?
>>>      
>> how do I find this out? I don't see any warning about TSC in guest, but I've
>> just started it..
>> n.
>
> Before worrying about the guest, is the host TSC stable?  What is the  
> host clocksource?
not sure, I'm not setting anything specifically, is this snippet of dmesg relevant:

[    1.148829] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    1.148934] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.149331] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.151831] hpet: hpet2 irq 40 for MSI
[    1.151962] hpet: hpet3 irq 41 for MSI
[    1.155930] hpet: hpet4 irq 42 for MSI
[    1.159937] hpet: hpet5 irq 43 for MSI
[    1.163943] hpet: hpet6 irq 44 for MSI
[    1.175955] Switching to clocksource tsc

so I guess I'm using hpet?
n.


> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
