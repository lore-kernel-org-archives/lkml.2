Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0KSLWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:22:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752929Ab0KSLWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:22:05 -0500
Date: Fri, 19 Nov 2010 11:22:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Christian Pellegrin <chripell@evolware.org>
Subject: Re: [PATCH] ASoC: uda134x - set reg_cache_default to uda134x_reg
Message-ID: <20101119112203.GH7233@rakim.wolfsonmicro.main>
References: <1290152886.10001.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290152886.10001.2.camel@mola>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 03:48:06PM +0800, Axel Lin wrote:
> After checking the code in 2.6.36,
> I found this is missing during multi-component conversion.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
