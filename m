Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122Ab2ERK1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:27:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:62028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161082Ab2ERK1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:27:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168040755"
Date: Fri, 18 May 2012 12:37:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix double free in wm8350 error path
Message-ID: <20120518103727.GK12015@sortiz-mobl>
References: <1337103940-31899-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337103940-31899-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Tue, May 15, 2012 at 07:45:40PM +0200, Johan Hovold wrote:
> Fix double free in probe error path introduced by the recent conversion
> of wm8350 to use regmap.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
