Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab0IKTpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:45:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:60004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0IKTph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:45:37 -0400
Message-Id: <89kc63$i1vccu@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,352,1280732400"; 
   d="scan'208";a="606056862"
Date: Sat, 11 Sep 2010 20:45:34 +0100
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: i915 blank screen and crash
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
References: <20100911184646.GA27154@ioremap.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100911184646.GA27154@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 22:46:46 +0400, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> I use the latest git tree as well as 2.6.35, 2.6.32 (both ubuntu lucid)
> and various 26-rc candidates with the same problem on Dell E4310 laptop:
> screen blanks when getting to X start. System works ok, but without
> screen (switch to text console does not help).

An eDP panel, yes we are indeed continuing to debug the link configuration
on those machines.

The current set of patches we have for eDP are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git

in the drm-intel-next branch. Jesse insists that he has a working eDP
machine on his desk, so maybe there is hope yet.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
