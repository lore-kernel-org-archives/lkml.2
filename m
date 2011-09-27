Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1I0JBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:01:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:43446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab1I0JBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:01:39 -0400
Message-Id: <e39f63$23ptfo@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,448,1312182000"; 
   d="scan'208";a="71103992"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: PCH reference clock cleanups
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 10:01:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:37 -0700, Keith Packard <keithp@keithp.com> wrote:
> Ok, so I'd love to know where in any PCH reference matter someone has
> found a place where the reference clock for any of the PLLs is
> anything other than 120MHz. Can someone find a reference for other frequencies?

Oddly in the diagram SSC4 is given as a 100MHz clock that can be used for
any output other than DP_A. However, the configuration register marks that
as being a test-only mode.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
