Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1JMNHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:07:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10939 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1JMNHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:07:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 13 Oct 2011 06:07:32 -0700
Date: Thu, 13 Oct 2011 16:07:07 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Stephen Warren <swarren@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v9 0/3] Add support for tegra2 based ventana board
Message-ID: <20111013130707.GM1001@tbergstrom-lnx.Nvidia.com>
References: <1318420387-6802-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE19D81@HQMAIL01.nvidia.com>
 <20111012223643.GA5368@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111012223643.GA5368@quad.lixom.net>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:36:43AM +0200, Olof Johansson wrote:
> On Wed, Oct 12, 2011 at 08:56:47AM -0700, Stephen Warren wrote:
> > pdeschrijver@nvidia.com wrote at Wednesday, October 12, 2011 5:53 AM:
> > > This patch set adds support for the tegra2 based ventana development board.
> > > 
> > > Boot tested on ventana.
> > > 
> > > Uses a table based approach to select the correct init function.
> > > 
> > > Provoke kernel warning when no suitable pinmux table can be found.
> > 
> > Whole series:
> > 
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > 
> > Thanks for following up on my picky comments:-)
> 
> Yes, thanks Peter.
> 
> Applied to for-3.2/features. I had to do some fixups since I applied it
> on top of some of Stephen's changes for gpio/pinmux, so please verify
> that I did the fixups correctly.

I just booted your tree on ventana. Works fine! Thanks!

Peter.
