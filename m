Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2GHWXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:23:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:52243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2GHWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="168801235"
Date: Mon, 9 Jul 2012 00:34:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Also restore GPIO IRQ masks after reset
Message-ID: <20120708223456.GF15345@sortiz-mobl>
References: <1340978140-11572-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1340978140-11572-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340978140-11572-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jun 29, 2012 at 02:55:40PM +0100, Mark Brown wrote:
> This ensures that if we are using a GPIO as a wake source it continues to
> function while we're suspended.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-core.c |    7 +++++++
>  1 file changed, 7 insertions(+)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
