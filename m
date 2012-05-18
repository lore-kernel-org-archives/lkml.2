Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761Ab2ERKx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:53:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:45535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab2ERKxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:53:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144812494"
Date: Fri, 18 May 2012 13:03:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: mc13xxx: Core should not be user visible
Message-ID: <20120518110318.GL12015@sortiz-mobl>
References: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, May 16, 2012 at 06:51:08PM +0100, Mark Brown wrote:
> Since the core is not usable without one of the bus modules it should not
> be presented in the UI but should instead be selected by the bus modules.
Patch applied, with Uwe suggestions added.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
