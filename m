Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0LPNfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:35:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0LPNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:35:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/9] TI DMM-TILER driver
Date: Thu, 16 Dec 2010 14:34:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Sin <davidsin@ti.com>, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161434.05768.arnd@arndb.de>
X-Provags-ID: V02:K0:uI4KS6nsLxD0Rh2bgHCOjVxVf2oQ8qufvltO72BIJQ8
 ++L7QME2UsrArlps09tCL5KY8Cg9pRKOW9tkiLEbJ5iVcRCKnM
 Jo2kaEY4Evop6Ooyp4BXc+8uX18PMZ8uwumyhV0WeinDQW4kF1
 DA41Y30iLZ9yoHwM+QR2+0d4HgKe2sDv2rQ7Ov6fDA58LWjeIA
 5YMdb6BKuCBoFdaWNTSjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, David Sin wrote:
> Tiling and Isometric Lightweight Engine for Rotation (TILER) driver
> =====
> 
> Dynamic Memory Manager (DMM) is a hardware block made by Texas Instruments.
> Within the DMM exists at least one TILER hardware component.  Its purpose is to
> organize video/image memory in a 2-dimensional fashion to limit memory
> bandwidth and facilitate 0 effort rotation and mirroring.  The TILER driver
> facilitates allocating, freeing, as well as mapping 2D blocks (areas) in the
> TILER container(s).  It also facilitates rotating and mirroring the allocated
> blocks or its rectangular subsections.

How does this relate to DRM/GEM? I don't understand too much about graphics
drivers, but it does sound like there is some overlap in functionality.

I guess at the very least the DMM should live in drivers/gpu/ instead of
drivers/misc, but perhaps it could be integrated more closely with the
existing code there.

	Arnd
