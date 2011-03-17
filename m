Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1CQXth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:49:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:7674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1CQXtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:49:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="898464751"
Date: Fri, 18 Mar 2011 00:49:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] mfd: Avoid copying data in WM8994 I2C write
Message-ID: <20110317234933.GG32172@sortiz-mobl>
References: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Mar 17, 2011 at 09:42:28PM +0000, Mark Brown wrote:
> As well as providing a trivial performance optimisation this also avoids
> allocating a copy of the message on the stack which is beneficial when
> doing large transfers.
All 3 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
