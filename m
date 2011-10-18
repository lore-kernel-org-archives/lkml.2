Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1JRLCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:02:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40654 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599Ab1JRLCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:02:46 -0400
Date: Tue, 18 Oct 2011 12:02:43 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: Prepare LZO cache for variable block sizes
Message-ID: <20111018110243.GA2046@opensource.wolfsonmicro.com>
References: <1318933633-5759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318933633-5759-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:27:13AM +0100, Mark Brown wrote:
> Give regcache_lzo_block_count() a copy of the map so that when we decide
> we want to make the LZO cache more controllable we can more easily do so.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

Thanks,
Dimitris
