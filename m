Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1AYWLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:11:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:21181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1AYWLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:11:15 -0500
Message-Id: <b7da2f$q83ub3@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,376,1291622400"; 
   d="scan'208";a="880933219"
Date: Tue, 25 Jan 2011 22:11:03 +0000
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [PATCH] drm/i915/sdvo: If at first we dont succeed in reading the response, wait
Cc: linux-kernel@vger.kernel.org
References: <4D3EB90C.9020901@t-online.de> <1295967967-26041-1-git-send-email-chris@chris-wilson.co.uk> <4D3F4849.4030905@t-online.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D3F4849.4030905@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 23:01:45 +0100, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> I think that patch also should be a candidate for 2.6.37.1 as it fixes a
> regression
> introduced in 2.6.37.

(Actually I think the bug is older than that...)

> Something new:
> 
> Have a look at the attached new log.  I connected a 2nd monitor, so
> there is a monitor attached to both
> the VGA-1 and DVI-1 connectors. At the framebuffer console prompt (no X
> running)
> I changed to console 2 and back to console 1. The log starts at the
> point of switching
> back to console 1. Now ... shouldn't I read something about a
> output_poll_execute for VGA-1?

In this case, no. VGA-1 has hw hotplug support, so that connector is not
polled but uses an interrupt instead.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
