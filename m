Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0KULuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 06:50:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:43031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0KULuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 06:50:00 -0500
Message-Id: <c6d829$pk1i4l@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="859883669"
Date: Sun, 21 Nov 2010 11:49:57 +0000
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com>
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 12:20:01 +0100, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
> Hi,
> 
>  I'm trying to track down a regression occuring in recent kernel : I
> get the DVI output of my intel G33 chipset through a Sapphire ADD2
> DVI-D SDVO adaptor card and it was working fine until
> kernel 2.6.37-rc1 :
> - all more recent kernels only give a black screen
> - I can log through ssh and no oops nor anything suspicious is in the log
> - I get an output if I uses the VGA builtin port.

Add drm.debug=0xe to your boot command line (or module options) and attach
the dmesg. We're obviously failing to detect the output over the SDVO
card, and hopefully we might have a reason in the debug log.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
