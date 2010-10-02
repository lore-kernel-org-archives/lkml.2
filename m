Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0JBOIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:08:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:7109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab0JBOH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:07:59 -0400
Message-Id: <8u3s94$gm2ivf@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,271,1283756400"; 
   d="scan'208";a="560024559"
Date: Sat, 02 Oct 2010 15:07:54 +0100
To: Julia Lawall <julia@diku.dk>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH 3/4] drivers/gpu/drm/i915/i915_gem.c: Add missing error handling code
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <1286027958-7333-3-git-send-email-julia@diku.dk>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1286027958-7333-3-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  2 Oct 2010 15:59:17 +0200, Julia Lawall <julia@diku.dk> wrote:
> Extend the error handling code with operations found in other nearby error
> handling code

Thanks, your fix was correct. Applied.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
