Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1CBKfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:35:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:14262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1CBKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="892934156"
Date: Wed, 2 Mar 2011 11:35:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] mfd: Convert WM831x interrupt masking to
 enable/disable operations
Message-ID: <20110302103519.GF16181@sortiz-mobl>
References: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Mar 01, 2011 at 08:12:44PM +0000, Mark Brown wrote:
> The WM831x interrupt masking support is a much better match for the genirq
> enable and disable operations than for the mask and unmask operations. The
> latter are intended to used during interrupt handling for temporary changes
> which isn't really practical on a slow bus. Convert the operations over to
> match this.
All 3 patches applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
