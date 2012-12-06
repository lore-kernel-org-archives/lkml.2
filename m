Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2LFOPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:15:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43854 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LFOPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:15:14 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: make sure all transfer has bits_per_word set
To: Jonas Gorski <jonas.gorski@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com,
        spi-devel-general@lists.sourceforge.net, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
In-Reply-To: <CAOiHx=nEmd9dQ297Oho=gmZTYfYgJ3o_+J2OFK=sRuRYNqzPxg@mail.gmail.com>
References: <1352452005-13789-1-git-send-email-ldewangan@nvidia.com> <CAOiHx=nEmd9dQ297Oho=gmZTYfYgJ3o_+J2OFK=sRuRYNqzPxg@mail.gmail.com>
Date: Thu, 06 Dec 2012 14:15:07 +0000
Message-Id: <20121206141507.86DCF3E0948@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 11:03:56 +0100, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> Hi,
> 
> On 9 November 2012 10:06, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> > When spi client does the spi transfer and does not sets
> > the bits_per_word for each transfer then set it as default
> > of spi device in spi core before calling low level transfer.
> 
> I like that (not that it counts ... )!
> 
> > Removing the similar code from spi-tegra20-slink driver as
> > it is not required.
> 
> Not sure if this should be part of *this* patch.
> Also spi-tegra20-slink isn't the only one fixing up the bits_per_word
> for transfers, so it would be nice if you could remove it from the
> other drivers, too.
> 
> In a future patch, maybe even do the same with speed_hz?

That sounds reasonable. Could you craft one up and see how it looks?

Thanks,
g.

