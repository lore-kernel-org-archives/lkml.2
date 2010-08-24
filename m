Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0HXVwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:52:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:22067 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0HXVwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:52:12 -0400
Message-Id: <89k83a$9drtkt@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,264,1280732400"; 
   d="scan'208";a="316536477"
Date: Tue, 24 Aug 2010 22:52:08 +0100
To: Ivan Bulatovic <combuster@gmx.com>
Subject: Re: [PATCH] drm/i915/tv: After disabling the pipe, use wait_for_vblank_off()
Cc: linux-kernel@vger.kernel.org, linux-gfx@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1282647815.2221.15.camel@localhost.localdomain> <1282662712-20493-1-git-send-email-chris@chris-wilson.co.uk> <1282684130.2199.25.camel@localhost.localdomain>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1282684130.2199.25.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 23:08:50 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> Unfotunately I still get TV connection detected :(

Jesse spotted the root cause and Linus has now pushed that fix for
intel_wait_for_vblank() out. This is just a very minor bug in comparison.
Can you please test against linus/master and check that resolves the
spurious TV detection for you?
Thanks.

-- 
Chris Wilson, Intel Open Source Technology Centre
