Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0KFTeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:34:23 -0400
Received: from snt0-omc1-s41.snt0.hotmail.com ([65.54.61.78]:26176 "EHLO
	snt0-omc1-s41.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283Ab0KFTeX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:34:23 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Nov 2010 15:34:22 EDT
Message-ID: <SNT127-W65587F1714D03CB57D611DE64D0@phx.gbl>
X-Originating-IP: [78.23.102.215]
From: Nico <segfault2@hotmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: AGP Aperture question
Date: Sat, 6 Nov 2010 20:28:13 +0100
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Nov 2010 19:28:13.0206 (UTC) FILETIME=[C0E13360:01CB7DE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org






Hi,

I just assembled a new machine here based on an MSI 770-C45 mobo with an Phenom II X4 955 CPU. Everything is running flawlessly (on 2.6.36), after fiddling a bit with my old disks, but today after going through the dmesg, I noticed the following which got me curious and would also like to know if I should worry about it or of it has any bad impact on something...

Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000


and later on in dmesg, I see the following...

PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture

I looked in my BIOS settings but couldn't find anything about Aperture or IOMMU. There's no such option at all in there. So, is the above something to be concerned about? Does it have any negative impact on the system?

Please CC me as I'm not subbed to the list :)

Thanks
 		 	   		  