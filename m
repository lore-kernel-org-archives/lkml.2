Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0EDJNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:13:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48769 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211Ab0EDJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:13:47 -0400
Subject: Re: linux-next: manual merge of the crypto tree with the arm tree
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <20100504125355.810e6f54.sfr@canb.auug.org.au>
References: <20100504125355.810e6f54.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 10:13:12 +0100
Message-ID: <1272964392.8533.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2010 09:13:16.0445 (UTC) FILETIME=[07DCC4D0:01CAEB6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2010-05-04 at 03:53 +0100, Stephen Rothwell wrote:
> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-omap2/devices.c between commit
> 883413341e479d4e9f9c69def4884b4c6e1cef4e ("ARM: 6046/1: ARM: OMAP:
> register PMU IRQs during board initialisation") from the arm tree and
> commit ee5500c45c4860a84bba502c6d9ef5af6395dad6 ("crypto: omap - Updates
> omap sham device related platform code") from the crypto tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks for fixing this. Looks fine to me.

Will

