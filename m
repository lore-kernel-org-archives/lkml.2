Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2BTRaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:30:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:51832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab2BTRaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:30:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108683343"
Date: Mon, 20 Feb 2012 18:37:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: Re: [PATCH] mfd, ab5500: Remove unneeded version.h include
Message-ID: <20120220173730.GI5387@sortiz-mobl>
References: <alpine.LNX.2.00.1201302206480.31586@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201302206480.31586@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Mon, Jan 30, 2012 at 10:08:44PM +0100, Jesper Juhl wrote:
> As 'make versioncheck' points out, there's no need for
> drivers/mfd/ab5500-core.c to #include <linux/version.h>, so this patch
> removes the unneeded include.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
