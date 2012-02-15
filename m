Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2BOW0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:26:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6140 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2BOW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:26:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 15 Feb 2012 14:26:06 -0800
Date: Thu, 16 Feb 2012 00:25:51 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Russell King" <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] Add tegra30 support for secondary cores
Message-ID: <20120215222551.GN16501@tbergstrom-lnx.Nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 10:27:43PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, February 09, 2012 4:48 PM:
> > This patchset introduces support for secondary cores on tegra30. It also
> > introduces some functions for the flowcontroller and adds basic support for
> > tegra30 powerdomains.
> 
> The code looks fine to me. I do notice the following when running
> "shutdown -h now":
> 
> [   27.762124] SMP: failed to stop secondary CPUs
> 
> So, this patch series makes the secondary cores boot OK, but not shut
> down it appears. Is that expected? It's probably something we can fix
> with a following on patch rather than re-spinning this series though?
> 

This seems to be a bug indeed. I will look at it next week when I'm back in
finland.

Cheers,

Peter.
