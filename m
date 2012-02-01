Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2BAKKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:10:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9046 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2BAKKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:10:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Feb 2012 02:10:22 -0800
Date: Wed, 1 Feb 2012 12:10:10 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] Add tegra30 support for secondary cores
Message-ID: <20120201101010.GN24948@tbergstrom-lnx.Nvidia.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <20120201083334.GM7399@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120201083334.GM7399@quad.lixom.net>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 09:33:34AM +0100, Olof Johansson wrote:
> Hi,
> 
> On Tue, Jan 31, 2012 at 06:40:38PM +0200, Peter De Schrijver wrote:
> > This patchset introduces support for secondary cores on tegra30. It also
> > introduces some functions for the flowcontroller and adds basic support for
> > tegra30 powerdomains.
> 
> It would be very useful to get a quick recap of what has changed since
> previous versions in the cover email, if not detailed in the individual
> patches (which it doesn't seem to be).
> 

Oops. I forgot about that. 

Here it is:

Changes in v2:

* moved chip id reading to fuse.c and cleanup code
* don't set bit 1 of SB_CTRL on Tegra20
* removed unused variables in tegra_cpu_reset_handler_init()

Cheers,

Peter.
