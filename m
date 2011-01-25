Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1AYOpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:45:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:14849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab1AYOpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:45:03 -0500
Message-Id: <b9dded$hokqnl@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,374,1291622400"; 
   d="scan'208";a="596273915"
Date: Tue, 25 Jan 2011 14:44:58 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output gets disabled/reenabled under load
Cc: jesse.barnes@intel.com, linux-kernel@vger.kernel.org
References: <4D3DC997.5040605@t-online.de> <0d30dc$krk6f6@orsmga001.jf.intel.com> <4D3EB90C.9020901@t-online.de> <0d30dc$krt8da@orsmga001.jf.intel.com> <4D3EDACF.8040702@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D3EDACF.8040702@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:14:39 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> Well, I don't know if openSuSE 11.3 is recent enough.
> Setup: 2 Monitors, attached to VGA1 and DVI1, resolution 1280x1024
> 
> xrandr  --output VGA1 --pos [1..768]
> ============================
> Everything ok. Works as expected.
> 
> xrandr --output VGA1 --pos 769

Just retested on my PineView netbook:

$ xrandr --output LVDS1 --mode 1024x600 \
         --output VGA1 --mode 1920x1080 --right-of LVDS1

is working fine.

The empty backtrace is most bizarre. Do you get a more reliable stacktrace
if you attach gdb before the crash?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
