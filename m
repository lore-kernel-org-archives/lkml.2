Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0IGUw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:52:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:27365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab0IGUw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:52:57 -0400
Message-Id: <8u3s8d$jgk7o2@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,330,1280732400"; 
   d="scan'208";a="654974722"
Date: Tue, 07 Sep 2010 21:52:45 +0100
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [git pull v2] i915
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andy Isaacson <adi@hexapodia.org>
References: <89kc63$i063ms@fmsmga002.fm.intel.com> <AANLkTi=pFSB5AfqXbPNUQUknbnCBwqUHdUVzR6jaZqaQ@mail.gmail.com> <8u3s94$geldgp@orsmga002.jf.intel.com> <20100907202934.GA24791@bombadil.infradead.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100907202934.GA24791@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 16:29:34 -0400, Kyle McMartin <kyle@mcmartin.ca> wrote:
> Hi Chris,
> 
> Without reverting ce171780, graphics don't come back after resuming on
> my x201s. (drm/i915: Enable RC6 on Ironlake.) Several users bisected
> failing graphics on resume to this commit, and I've confirmed that
> reverting it does indeed fix the problem.

Reverted. Thanks.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
