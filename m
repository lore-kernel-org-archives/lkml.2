Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1AKOHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:07:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:15029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066Ab1AKOHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:07:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,307,1291622400"; 
   d="scan'208";a="645688381"
Date: Tue, 11 Jan 2011 15:07:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Flag WM831x /IRQ as a wake source
Message-ID: <20110111140737.GH6616@sortiz-mobl>
References: <1294250161-10307-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294250161-10307-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jan 05, 2011 at 05:56:01PM +0000, Mark Brown wrote:
> The WM831x can generate wake events, some unconditionally, so flag
> the primary IRQ as a wake source in order to help the CPU treat the
> /IRQ signal appropriately.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
I applied this patch as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
