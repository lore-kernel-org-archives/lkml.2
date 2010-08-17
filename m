Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0HQJaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:30:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54904 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757227Ab0HQJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:30:17 -0400
Date: Tue, 17 Aug 2010 10:30:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the
 samsung tree
Message-ID: <20100817093014.GA18622@rakim.wolfsonmicro.main>
References: <20100817122137.aa6f269e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817122137.aa6f269e.sfr@canb.auug.org.au>
X-Cookie: My NOSE is NUMB!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:21:37PM +1000, Stephen Rothwell wrote:

> Today's linux-next merge of the sound-asoc tree got a conflict in
> arch/arm/mach-s3c64xx/mach-smdk6410.c between commit
> 96e9d908a7b5b5be774ba26aca0d6633e7c97f63 ("ARM: SMDK6410: Register AC97
> controller") from the samsung tree and commit
> f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC: multi-component - ASoC
> Multi-Component Support") from the sound-asoc tree.

Oh dear, the AC'97 controller addition was supposed to make it into
2.6.36.

> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks.
