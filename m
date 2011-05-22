Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1EVWFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:05:02 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:52525 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1EVWFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:05:00 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 May 2011 18:04:59 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 22 May 2011 22:56:27 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: <linux-kernel@vger.kernel.org>
Subject: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20radeon?=
 =?UTF-8?Q?=20driver=2E?=
Message-ID: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello,

 I have an x86_64 system with a VIA chipset and 4GB of RAM. The 
 mainboard
 is an ASUS M2V where the bios-setup has an option called "Map around
 memory hole" and I have an "ATI Technologies Inc RV710 [Radeon HD 
 4350]"
 graphics card according to lspci.

 Now one of the following things happen to my system:

 1) With the bios-option enabled and no kernel parameters I get the 
 following error:

 [drm:r600_ring_test] *ERROR* radeon: ring test failed 
 (scratch(0x8504)=0xCAFEDEAD)
 radeon 0000:02:00.0: disabling GPU acceleration

 and then I can not use any 3d-acceleration. I also get the message

 Looks like a VIA chipset. Disabling IOMMU. Override with iommu=allowed

 2) With the bios-option enabled and "mem=3072M" I can not use only 3GB 
 of RAM,
 but the radeon card works.

 3) With the bios-option enabled and "iommu=allowed" I get 4GB of RAM 
 and
 the radeon card works. But I wonder whether this can have any bad 
 effects?

 4) Without the bios-option (and without any kernel parameters) I do not
 get the "Looks like a VIA chipset. Disabling IOMMU. Override with 
 iommu=allowed"
 message, but strangely linux shows only about 3GB of RAM.

 I did not try other combinations. Now my questions are

 A) Is this a bug in the radeon driver? Or maybe not, since 
 Documentation/x86/x86_64/boot-options.txt
 seems to imply that for >3GB an iommu is required?

 B) Is it safe to use iommu=allowed in my case ? If not, what problems 
 will I encounter and what
 options should I use instead? Will I be stuck with 3GB of RAM?

 Please cc me if you answer, since I am not subscribed.

 Thank you.


