Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab2IEXnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:43:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42938 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774Ab2IEXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:43:46 -0400
Date: Thu, 6 Sep 2012 07:43:41 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>, kernel-janitors@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/spi/spi-sh-hspi.c: drop frees of devm_
 alloc'd data
Message-ID: <20120905234340.GH10580@opensource.wolfsonmicro.com>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
 <1346517191-8794-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346517191-8794-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 06:33:08PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm free functions should not have to be explicitly used.

Applied, thanks.
