Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0I1Rcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:32:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41466 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751010Ab0I1Rcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:32:46 -0400
Date: Tue, 28 Sep 2010 10:33:04 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH -next] sound/soc: fix printk format warning
Message-ID: <20100928173303.GD10739@opensource.wolfsonmicro.com>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
 <20100928095846.9d4c7641.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928095846.9d4c7641.randy.dunlap@oracle.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:58:46AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>

> Fix dev_printk format warning:

> sound/soc/codecs/wm8985.c:731: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Takashi already fixed that (and the change already seems to be in
-next...).

When reporting type based warnings please always report the
architecture you're building for, GCC seems to only generate the
warnings if there's a difference in the underlying typedef which means
that they don't always trigger on every architecture.
