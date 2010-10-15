Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0JOKE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:04:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40709 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754404Ab0JOKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:04:55 -0400
Date: Fri, 15 Oct 2010 11:04:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: linux-next: manual merge of the sound-asoc tree with Linus'
 tree
Message-ID: <20101015100452.GB14782@rakim.wolfsonmicro.main>
References: <20101015115251.015b08d5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015115251.015b08d5.sfr@canb.auug.org.au>
X-Cookie: Don't get even -- get odd!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:52:51AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the sound-asoc tree got a conflict in
> arch/powerpc/platforms/85xx/p1022_ds.c between commit
> dc1c41f450a5f201f1d8c19aef32319f3b84c273 ("powerpc/85xx: Fix compile
> issue with p1022_ds due to lmb rename to memblock") from Linus' tree and
> commit 2c184cd393d1410bb43ac656a6480849fe886b1d ("powerpc/85xx: add DIU
> support to the Freecale P1022DS reference board") from the sound-asoc
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I had to apply the reverse of that to to apply on ASoC so this looks to
be the best fix :)
