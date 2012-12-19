Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2LSUfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:35:54 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63034 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2LSUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:35:43 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: tegra: sequence compatible strings as per preference
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121110170741.GA17689@avionic-0098.mockup.avionic-design.de>
References: <1352452052-13823-1-git-send-email-ldewangan@nvidia.com> <509D37B8.8020606@wwwdotorg.org> <20121109171008.GX23807@opensource.wolfsonmicro.com> <509D3D46.7060102@wwwdotorg.org> <20121110170741.GA17689@avionic-0098.mockup.avionic-design.de>
Date: Wed, 19 Dec 2012 17:00:09 +0000
Message-Id: <20121219170009.54EE83E0C34@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2012 18:07:42 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> On Fri, Nov 09, 2012 at 10:28:38AM -0700, Stephen Warren wrote:
> > On 11/09/2012 10:10 AM, Mark Brown wrote:
> > > On Fri, Nov 09, 2012 at 10:04:56AM -0700, Stephen Warren wrote:
> > > 
> > >> However just FYI, it should not be necessary for correctness; The
> > >> DT matching order is supposed to be driven purely by the order of
> > >> the compatible values in the DT now, and not affected by the
> > >> order of values in the table. (This wasn't always the case, but
> > >> was a bug that was fixed IIRC by Thierry Reding).
> > > 
> > > I guess the driver is being used backported in older kernels which
> > > don't have that fix?
> > 
> > That sounds likely. Laxman, it'd be a good idea to track down the fix
> > to the DT matching code and backport it, so that hard-to debug issues
> > aren't caused by the lack of that patch!
> 
> Unfortunately the patch that was supposed to fixed this caused a
> regression and was therefore reverted. Rob (Cc'ed) said there was a
> patch to fix it properly and was supposed to go into 3.6 but it seems
> that never happened. Rob, what's the status on this?
> 
> The revert is here: bc51b0c22cebf5c311a6f1895fcca9f78efd0478

Rob, ping on this. I think we talked about it on IRC, but I cannot
remember what was said.... I must be getting old.

g.

