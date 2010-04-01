Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0DAVpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:45:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:42911 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0DAVpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:45:04 -0400
Date: Thu, 1 Apr 2010 17:45:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 2.6.33.1 pwc (quickcam pro 4000 is broken)
Message-ID: <alpine.DEB.2.00.1004011743460.4845@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a long time ago I used to use the binary only pwc driver; I noticed
support is in the kernel now for (pwc)-based Logitech Quickcam Pro 4000
but, it doesn't work:

[   78.866729] pwc: Wrong size (67108864) needed to be len_per_image=462848 or total_size=925696

..

[  182.914969] pwc: Philips webcam module removed.
[  189.523289] pwc: Philips webcam module version 10.0.13 loaded.
[  189.523290] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
[  189.523292] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
[  189.523293] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
[  189.524403] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
[  189.524430] pwc: Registered as video0.
[  189.532670] input: PWC snapshot button as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/input/input8
[  189.532742] usbcore: registered new interface driver Philips webcam
[  196.540057] pwc: isoc_init() submit_urb 0 failed with error -28
[  196.540067] pwc: isoc_init() submit_urb 1 failed with error -28

Justin.

