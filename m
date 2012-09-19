Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2ISPav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:30:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:30243 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab2ISPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:30:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="207939839"
Date: Wed, 19 Sep 2012 17:30:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, peter.ujfalusi@ti.com, s-guiriec@ti.com
Subject: Re: [PATCH 0/6] some small cleanups for palmas and DT support
Message-ID: <20120919153044.GJ28670@sortiz-mobl>
References: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346154460-20031-1-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme,

On Tue, Aug 28, 2012 at 01:47:34PM +0200, Graeme Gregory wrote:
> This series does a couple of small improvements to the palmas mfd and
> regulator drivers. It does a little re-organisation of the header file
> to better implement DT in regulator driver and then add DT handling.
I applied those 6 patches:

- I fixed patch #2 comment.
- I'm queueing it up for 3.7 but I'm expecting you to provide me with a
  follow up patch documenting the new device tree bindings.
- I included patch #6, although I'd really like to get Mark's ACK for it.
  Also, I add to add a #include <linux/of.h> for it to build on !DT platforms.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
