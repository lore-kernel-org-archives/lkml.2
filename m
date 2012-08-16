Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2HPK6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:58:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38725 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab2HPK6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:58:06 -0400
Date: Thu, 16 Aug 2012 11:58:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (regulator tree related)
Message-ID: <20120816105803.GI15365@opensource.wolfsonmicro.com>
References: <20120816151605.b0a9932005b541956288ce96@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816151605.b0a9932005b541956288ce96@canb.auug.org.au>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 03:16:05PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

Applied, thanks.  I can't help but thinking that slab.h should just be
automatically included, it's so widely used and frequently included
implicitly that I bet it causes more time to be burned on this sort of
error than has ever been saved by not referencing it.
