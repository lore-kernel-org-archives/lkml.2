Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1IETnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:43:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34412 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752102Ab1IETnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:43:00 -0400
Date: Mon, 5 Sep 2011 12:42:55 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix regmap compilation with CONFIG_DEBUGFS=n
Message-ID: <20110905194254.GA11107@opensource.wolfsonmicro.com>
References: <1315250978-4242-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315250978-4242-1-git-send-email-lars@metafoo.de>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 09:29:38PM +0200, Lars-Peter Clausen wrote:
> With CONFIG_DEBUGFS disabled the regmap compilation fails with the following
> errors:

> 	drivers/base/regmap/regcache.o: In function `regmap_debugfs_initcall':
> 	drivers/base/regmap/internal.h:96: multiple definition of `regmap_debugfs_initcall'
> 	drivers/base/regmap/regmap.o:drivers/base/regmap/internal.h:96: first defined here
> 	drivers/base/regmap/regcache.o: In function `regmap_debugfs_init':

I sense that this doesn't actually happen in mainline...
