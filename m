Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab2KVUMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:12:42 -0500
Received: from mailout07.t-online.de ([194.25.134.83]:42765 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2KVUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:12:39 -0500
X-Greylist: delayed 5417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 15:12:39 EST
Message-ID: <50AE44C4.1060606@t-online.de>
Date: Thu, 22 Nov 2012 16:29:08 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "xorg-devel@lists.x.org Development" <xorg-devel@lists.x.org>,
        linux-kernel@vger.kernel.org
Subject: drm_gem_create_mmap_offset / intel_uxa_prepare_access bo problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Gc1U1OZCZhdwgIDks09ZfrC1fdU28-ztWHeCz9bU-y+5ZgpCMTQu4MewxXOQtZtg95
X-TOI-MSGID: 100ca3b9-41a7-445d-8d34-9679f578ccf1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris!

Problem:
=======
Slowdown of system, missing icons after 16 days kernel uptime and 12 days Xserver uptime.
Xorg log: flooded with "(WW) intel(0): intel_uxa_prepare_access: bo map (use gtt? 1, access 1) failed: No space left on device" lines
dmesg: flooded with "[drm:drm_gem_create_mmap_offset] *ERROR* failed to allocate offset for bo 0" entries


Hardware
=======
AOpen i915GMm-hfs, Pentium-M Dothan

Software:
=======
linux kernel 3.6.6
full Xorg git master, fetch/build 10 November 2012,
video-intel: git f5d79b202dd448e61ab6ffce26fe9cbf9051d770
xserver: git 011f8458805e443ac9130865d2840a929a00cabf
rest of system openSuSE 12.1

Any idea?

cu,
  Knut
