Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2BGSaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:30:01 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:54390 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2BGS35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:29:57 -0500
Date: Tue, 7 Feb 2012 19:29:44 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
Message-ID: <20120207182944.GA8595@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <20120207145205.GA22034@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207145205.GA22034@citd.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 15:52, Matthias Schniedermeyer wrote:

> I guess this whole mess is Mainboard specifc.
> I have a another, very similar system but with an Asus P8H67-M PRO 
> Mainbaord.
> 
> I just remotly booted that machine into 3.2.5, so i can't verify if the 
> sound works, but as the dmesg-output appears identical to the previous 
> boot of 3.2.0 so i guess i will work.
> 
> This is all i get for the system for aspm
> dmesg | grep -i aspm
> [    0.777824] e1000e 0000:02:00.0: Disabling ASPM L0s
> 
> So that mainboard has another BIOS/UEFI-Firmware and the 
> PCIe-PCI-Bridge, the Soundblaster-Live is behind, is from another 
> manufacture.
> 
> lspci -v -s 5:0
> 05:00.0 PCI bridge: ASMedia Technology Inc. ASM108x PCIe to PCI Bridge Controller (rev 01) (prog-if 01 [Subtractive decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
>         I/O behind bridge: 0000b000-0000bfff
>         Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Device 8489

Now that i'm back home i could test this other machine.
Unpatched 3.2.5 works fine, i guess because of the different Bridge-Chip 
and/or Firmware.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

