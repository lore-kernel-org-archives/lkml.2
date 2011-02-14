Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1BNWmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:42:32 -0500
Received: from waste.org ([173.11.57.241]:50911 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1BNWm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:42:28 -0500
Subject: Re: [PATCH 2/5] drivers/char/hw_random/omap-rng.c: Convert
 release_resource to release_region/release_mem_region
From: Matt Mackall <mpm@selenic.com>
To: Julia Lawall <julia@diku.dk>
Cc: Deepak Saxena <dsaxena@plexity.net>, kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1297599132-7226-3-git-send-email-julia@diku.dk>
References: <1297599132-7226-1-git-send-email-julia@diku.dk>
	 <1297599132-7226-3-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 16:42:24 -0600
Message-ID: <1297723344.5929.28.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-13 at 13:12 +0100, Julia Lawall wrote:
> Request_region should be used with release_region, not release_resource.
> 
> The local variable mem, storing the result of request_mem_region, is
> dropped and instead the pointer res is stored in the drvdata field of the
> platform device.  This information is retrieved in omap_rng_remove to
> release the region.  The drvdata field is not used elsewhere.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Looks ok to me, Herbert?

-- 
Mathematics is the supreme nostalgia of our time.


