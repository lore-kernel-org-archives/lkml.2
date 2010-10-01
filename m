Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0JAM2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:28:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:18553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0JAM23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:28:29 -0400
Message-Id: <89k77n$p3lgk1@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,266,1283756400"; 
   d="scan'208";a="842711681"
Date: Fri, 01 Oct 2010 13:28:25 +0100
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: 2.6.36-rc5 i915 regression
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <201010011300.06298.johannes.hirte@fem.tu-ilmenau.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201010011300.06298.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 13:00:05 +0200, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> With 2.6.36-rc5 and later my netbook is unusable. After login on X (KDE) the
> screen gets totally garbled, under X and console too. The log shows me this
> messages:

My humble apologies, fixed in 2.6.36-rc6:

commit 9b74f7348f214b1f99819f0d0da4a1cbabb1e740
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Sep 22 19:10:44 2010 +0100

    drm/i915: Fix 945GM regression in e259befd
    
    A minor typo caused a single fence register to be incorrectly
    programmed, resulting in occassional tiling corruption.
    
    Reported-and-tested-by: Hans de Bruin <bruinjm@xs4all.nl>
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=18962
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@kernel.org

It appears to have bitten worse than just the occasional gfx corruption.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
