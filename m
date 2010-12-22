Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab0LVTtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:49:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:12624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0LVTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:49:16 -0500
Message-Id: <5b55a1$j1r2sh@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,214,1291622400"; 
   d="scan'208";a="639470481"
Date: Wed, 22 Dec 2010 19:49:13 +0000
To: Stephen Clark <sclark46@earthlink.net>, sclark46@earthlink.net
Subject: Re: I915 driver locks up
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4D125430.1020708@earthlink.net>
References: <4D0D1516.3040404@earthlink.net> <4D0D19FF.4020600@earthlink.net> <5b55a1$j0av6h@fmsmga002.fm.intel.com> <4D0D44A1.8090501@earthlink.net> <5b55a1$j0e7cc@fmsmga002.fm.intel.com> <4D0E7D43.9010409@earthlink.net> <4D10D2C3.8050508@earthlink.net> <4D125430.1020708@earthlink.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 14:40:32 -0500, Stephen Clark <sclark46@earthlink.net> wrote:
> Hi Chris,
> 
> Just wanted to say I downloaded the latest drm_fixes from Dave Airlie 
> and tried them
> on 2.6.37rc7 and got the same gpu hang with the screen tearing 
> horizontally. I have
> the the intel gpu dump and a cat of the i915_error_state. Together they 
> are over
> 2 megabytes. Should I send them to you directly since they seem to big 
> for the mailing
> list.

Please do, or open a bug on bugs.freedesktop.org so that the error state
doesn't get lost. The intel_gpu_dump should be redundant, as the same
information, and more, is captured in the i915_error_state.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
