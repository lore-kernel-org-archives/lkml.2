Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab2BIVwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:52:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2BIVwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:52:18 -0500
Date: Thu, 9 Feb 2012 21:52:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] Fix mc13xxx regulator build on sparc64
Message-ID: <20120209215212.GI23916@ZenIV.linux.org.uk>
References: <20120209.164301.1049075777681222673.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209.164301.1049075777681222673.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 04:43:01PM -0500, David Miller wrote:
> 
> Since mc13xxx-regulator-core.c and the actual drivers can get built
> into seperate modules, you have to export the DT support symbols
> "mc13xxx_get_num_regulators_dt" and "mc13xxx_parse_regulators_dt"
> otherwise the allmodconfig build fails on sparc64.

... and not just sparc, either - i386 allmodconfig and powerpc ones run into
the same thing.
