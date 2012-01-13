Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2AMWpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:45:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57923 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932920Ab2AMWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:45:38 -0500
Date: Fri, 13 Jan 2012 22:45:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulators/db8500: split off shared dbx500 code
Message-ID: <20120113224534.GA31074@opensource.wolfsonmicro.com>
References: <1326468631-12041-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326468631-12041-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 04:30:31PM +0100, Linus Walleij wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> 
> As we progress with DB5500 and future voltage domain regulators
> based on very similar hardware as found in the DB8500 PRCMU,
> it makes sense to split off the generic parts and introduce
> some generic debug code for the DBx500 regulators. This patch
> accoplish a basic abstraction of the DBx500 voltage domain
> regulators.

Applied, thanks.
