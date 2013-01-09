Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3AILtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:49:18 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44713 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757182Ab3AILtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:49:16 -0500
Date: Wed, 9 Jan 2013 11:48:57 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Joseph Lo <josephl@nvidia.com>
Subject: Re: linux-next: manual merge of the tegra tree with the  tree
Message-ID: <20130109114856.GC1462@mudshark.cambridge.arm.com>
References: <20130109135816.2d65e46e24391fb56a09fd76@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109135816.2d65e46e24391fb56a09fd76@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 02:58:16AM +0000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tegra tree got a conflict in
> arch/arm/mach-tegra/headsmp.S between commit bc4f1bdabc89 ("ARM:
> coresight: common definition for (OS) Lock Access Register key value")
> from the arm-perf tree and commit 2a3eb5bc45bd ("ARM: tegra: make device
> can run on UP") from the tegra tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Argh, given that these two trees won't likely meet outside of next until
they hit torvalds, I'll just drop my tegra change from hw-breakpoint as it's
only cosmetic. I can requeue it via Stephen later on.

Thanks,

Will
