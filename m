Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1AaAqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 19:46:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:5791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1AaAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 19:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="882557660"
Date: Mon, 31 Jan 2011 01:45:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert adp5520 to dev_pm_ops
Message-ID: <20110131004558.GG2565@sortiz-mobl>
References: <1295559946-3947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295559946-3947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jan 20, 2011 at 09:45:46PM +0000, Mark Brown wrote:
> There is a move to deprecate bus-specific PM operations and move to
> using dev_pm_ops instead in order to reduce the amount of boilerplate
> code in buses and facilitiate updates to the PM core. Do this move for
> the adp5520 driver.
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
