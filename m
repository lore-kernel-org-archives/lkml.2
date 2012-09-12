Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab2ILQMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:12:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56630 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab2ILQMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:12:21 -0400
X-Sasl-enc: zrusNAjlpJiTW8MGWDmKwRNctR3jU2y32Zh/xGsLabsV 1347466340
Date: Wed, 12 Sep 2012 09:12:19 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>,
        Felipe Balbi <balbi@ti.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the tegra tree with the  tree
Message-ID: <20120912161219.GB7273@kroah.com>
References: <20120912164353.6fb8b35ff534088a79792acd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912164353.6fb8b35ff534088a79792acd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:43:53PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tegra tree got a conflict in
> arch/arm/mach-tegra/devices.c arch/arm/mach-tegra/devices.h between
> commits 2db4ddfe6e23 ("ARM: pmu: remove arm_pmu_type enumeration") from
> the arm-perf tree and 1ba8216f0bc0 ("usb: move phy driver from mach-tegra
> to drivers/usb") from the usb tree and commit ba07ee57d4bc ("ARM: tegra:
> remove dead code") from the tegra tree.
> 
> The latter removed the files, so I did that (no action is required).

Stephen (Warren that is), should be fixing this up in his tree soon, as
he will be including the same patchset that caused this problem in his
tree to resolve this.

thanks,

greg k-h
