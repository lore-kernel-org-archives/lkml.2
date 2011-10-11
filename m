Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1JKIE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:04:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:62925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1JKIEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:04:52 -0400
Message-Id: <d08817$1q4huf@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,522,1312182000"; 
   d="scan'208";a="60966863"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 00/24] MacBook Air patch sequence (v2)
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com>
Date: Tue, 11 Oct 2011 09:04:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011 18:09:32 -0700, Keith Packard <keithp@keithp.com> wrote:
> Ok, so I've split all of the changes into bite-sized pieces so that
> they should make sense individually now. I've also added the same
> asynchronous power control to the panel power, this reduces the
> module load time down to about 700ms on my MacBook Air, which is
> pretty nice.
> 
> Given the length of the series, I don't think this should all land in
> 3.1, however I'd like opinions on whether I should push this subset,
> which makes the MacBook Air work, into drm-intel-fixes and send that
> along.

I can confirm that these indeed make the MBA (this one at least!) work,
but I don't have any other eDP device with which to cross-check.

Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
