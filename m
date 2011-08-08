Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1HHRvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:51:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44666 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1HHRvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi2CXyAoy56-SdaD5YFzXW6W4wP6mnH+bVvRR3i_Mhk2A@mail.gmail.com>
References: <1312582534-10871-1-git-send-email-swarren@nvidia.com>
 <1312582534-10871-2-git-send-email-swarren@nvidia.com> <20110806174519.GB31966@ponder.secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF049F172168@HQMAIL01.nvidia.com> <CAOesGMi2CXyAoy56-SdaD5YFzXW6W4wP6mnH+bVvRR3i_Mhk2A@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 8 Aug 2011 11:50:47 -0600
X-Google-Sender-Auth: Uzj8zN7V9o_KtginLsesDoFoydY
Message-ID: <CACxGe6ubndfYNxgRfrLtCZ8cP0FddwTpG_FBZKXVZb0OHJVt6w@mail.gmail.com>
Subject: RE: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
To: Stephen Warren <swarren@nvidia.com>
Cc: Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 8, 2011 8:26 AM, "Stephen Warren" <swarren@nvidia.com> wrote:
>
> Grant Likely wrote at Saturday, August 06, 2011 11:45 AM:
> > On Fri, Aug 05, 2011 at 04:15:34PM -0600, Stephen Warren wrote:
> > > irq_to_gpio is deprecated and in the process of being removed. Make that
> > > happen now for ARM Tegra.
> > >
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >
> > Applied both.  Thanks.
>
> Didn't you want an Ack by a Tegra maintainer first?

It looks like a pretty low risk change.  I didn't see much risk in
picking it up and getting it off my plate.  I can always pull things
back out of my tree if someone complains.  I'll add Olof's ack before
it gets into linux-next.

>
> I assume they were both applied to gpio-next (although a fresh fetch  of that
> doesn't show the commits)

I can't push it out until after 3.1-rc1 is released because it is
targeted at 3.2 now.

g.
