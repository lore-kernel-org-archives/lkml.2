Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0LTSxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:53:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:44266 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab0LTSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:53:39 -0500
Message-Id: <849307$arcbdv@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,203,1291622400"; 
   d="scan'208";a="364260799"
Date: Mon, 20 Dec 2010 18:53:35 +0000
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
In-Reply-To: <201012201912.19051.arnd@arndb.de>
References: <201012201912.19051.arnd@arndb.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 19:12:19 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> Commit c64f7ba5f10 "agp/intel: Remove confusion of stolen entries not stolen memory" caused a regression on my Intel G45 based system, using the VESA
> Xorg driver or uvesafb. I have not tried if i915 with KMS shows the same
> behaviour, but can try if necessary.

I'm very confused as to how this would have impacted the VESA video
driver. Any clues as to what VESA is doing? And what is the nature of
the regression?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
