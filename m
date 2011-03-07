Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1CGRLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:11:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:45383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1CGRLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:11:13 -0500
Message-Id: <b7da2f$ql6u9s@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,278,1297065600"; 
   d="scan'208";a="894662972"
Date: Mon, 07 Mar 2011 17:07:48 +0000
To: roel <roel.kluin@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: index i shadowed in 2nd loop
References: <4D750F32.5050106@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4D750F32.5050106@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 18:00:34 +0100, roel <roel.kluin@gmail.com> wrote:
> Index i was already used in thhe first loop

Probably related to https://bugzilla.kernel.org/show_bug.cgi?id=19512
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
