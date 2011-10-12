Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1JLWgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:36:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53444 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1JLWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:36:39 -0400
Date: Wed, 12 Oct 2011 15:36:43 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v9 0/3] Add support for tegra2 based ventana board
Message-ID: <20111012223643.GA5368@quad.lixom.net>
References: <1318420387-6802-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE19D81@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE19D81@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 08:56:47AM -0700, Stephen Warren wrote:
> pdeschrijver@nvidia.com wrote at Wednesday, October 12, 2011 5:53 AM:
> > This patch set adds support for the tegra2 based ventana development board.
> > 
> > Boot tested on ventana.
> > 
> > Uses a table based approach to select the correct init function.
> > 
> > Provoke kernel warning when no suitable pinmux table can be found.
> 
> Whole series:
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks for following up on my picky comments:-)

Yes, thanks Peter.

Applied to for-3.2/features. I had to do some fixups since I applied it
on top of some of Stephen's changes for gpio/pinmux, so please verify
that I did the fixups correctly.


-Olof
