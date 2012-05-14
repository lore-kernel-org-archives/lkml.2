Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2ENVCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:02:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:64978 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2ENVCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143050279"
Date: Mon, 14 May 2012 23:12:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm831x: Don't try to flag IRQ 0 as a wake source
Message-ID: <20120514211206.GL12740@sortiz-mobl>
References: <1336942425-26826-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336942425-26826-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, May 13, 2012 at 09:53:45PM +0100, Mark Brown wrote:
> If we've not got a primary IRQ we shouldn't be trying to flag IRQ 0 as a
> wake source.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
