Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2CAAgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:36:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:14941 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2CAAgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72058862"
Date: Thu, 1 Mar 2012 01:43:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com
Subject: Re: [PATCH 3.3] mfd: Correct readability of WM8994 DC servo 4E
 register
Message-ID: <20120301004351.GC9008@sortiz-mobl>
References: <1330529879-5345-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330529879-5345-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Feb 29, 2012 at 03:37:59PM +0000, Mark Brown wrote:
> It should be marked as readable but wasn't, breaking DC servo operation.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This needs to go in for 3.3, it's a substantial regression.
I applied it to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
