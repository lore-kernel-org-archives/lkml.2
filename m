Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0HQJbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:31:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54934 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932123Ab0HQJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:31:50 -0400
Date: Tue, 17 Aug 2010 10:31:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the  tree
Message-ID: <20100817093149.GB18622@rakim.wolfsonmicro.main>
References: <20100817122404.ac35bbdb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817122404.ac35bbdb.sfr@canb.auug.org.au>
X-Cookie: My NOSE is NUMB!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:24:04PM +1000, Stephen Rothwell wrote:

> After merging the slab tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:

> sound/soc/codecs/wm8974.c: In function 'wm8974_probe':
> sound/soc/codecs/wm8974.c:610: warning: unused variable 'wm8974'

This is already fixed - just waiting for an ack on the patch, should
appear in -next tomorrow.
