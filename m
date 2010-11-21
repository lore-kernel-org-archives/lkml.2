Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0KUUce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 15:32:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:1676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab0KUUcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:33 -0500
Message-Id: <b9dded$h5cocn@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,232,1288594800"; 
   d="scan'208";a="576086423"
Date: Sun, 21 Nov 2010 20:32:30 +0000
To: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <4CE95893.8040008@gmail.com>
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com> <c6d829$pk1i4l@fmsmga001.fm.intel.com> <4CE95893.8040008@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 18:36:19 +0100, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
> I attached the dmesg from the latest git kernel (commit 
> b86db4744230c94e480de56f1b7f31117edbf193). Do you need the same 
> information with a working kernel ?

It found the SDVO DVI-D device, successfully queried its modelines, and
attached it to a crtc and framebuffer... In all appearances it should be
working. Can you attach the Xorg.log and xrandr output?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
