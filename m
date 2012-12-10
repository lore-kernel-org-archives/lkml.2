Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2LJDUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:20:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33922 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab2LJDUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:20:01 -0500
Date: Mon, 10 Dec 2012 12:19:55 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: lp8788-buck: Kill _gpio_request function
Message-ID: <20121210031954.GC10927@opensource.wolfsonmicro.com>
References: <1354872181.15243.1.camel@phoenix>
 <1354872313.15243.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354872313.15243.3.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:25:13PM +0800, Axel Lin wrote:
> Simply use devm_gpio_request_one() instead.

Applied, thanks.

Milo, you don't have a MAINTAINERS entry for this chip - would you mind
sending a patch adding one as you are reviewing patches for the driver?
This will ensure that people send you patches for review.
