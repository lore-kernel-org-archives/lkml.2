Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1FTKQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:16:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:49452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab1FTKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,392,1304319600"; 
   d="scan'208";a="17211716"
Date: Mon, 20 Jun 2011 12:16:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Fix WM8994 IRQ register cache restore on resume
Message-ID: <20110620101609.GC22420@sortiz-mobl>
References: <1307443782-14809-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307443782-14809-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jun 07, 2011 at 11:49:42AM +0100, Mark Brown wrote:
> When the byte swap was factored out into the per-register I/O functions
> the register restore for the IRQ mask cache (which we use and store in
> CPU native format for the interrupt handler) was not updated to do a byte
> swap when it uses the bulk I/O. Fix this by writing the cache out one
> register at a time.
Thanks, patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
