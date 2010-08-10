Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0HJPA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:00:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40248 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932143Ab0HJPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:00:54 -0400
Date: Tue, 10 Aug 2010 16:00:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: tps6586x - add regulator_unregister() in
 tps6586x_regulator_remove()
Message-ID: <20100810150052.GK6416@rakim.wolfsonmicro.main>
References: <1281340686.20518.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281340686.20518.4.camel@mola>
X-Cookie: Auction:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 03:58:06PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

>  
> -	platform_set_drvdata(pdev, ri);
> +	platform_set_drvdata(pdev, rdev);
>  

This would've been easier to review if you'd mentioned in the changelog
that there were no users of the current platform data, just to show that
you'd checked.
