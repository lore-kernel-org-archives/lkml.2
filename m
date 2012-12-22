Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2LVKTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 05:19:13 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:44202 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LVKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 05:19:12 -0500
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2012 05:19:11 EST
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/5] spi: fix return value check in hspi_probe().
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121219163914.GN5032@mwanda>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com> <1355271894-5284-6-git-send-email-tipecaml@gmail.com> <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com> <20121219151154.937EC3E0AD7@localhost> <20121219163914.GN5032@mwanda>
Date: Sat, 22 Dec 2012 09:56:20 +0000
Message-Id: <20121222095620.83E243E07FA@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 19:39:14 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Dec 19, 2012 at 03:11:54PM +0000, Grant Likely wrote:
> > On Tue, 11 Dec 2012 16:36:27 -0800 (PST), Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:
> > > 
> > > Hi
> > > 
> > > > According to its documentation, clk_get() returns a "valid IS_ERR() condition
> > > > containing errno", so we should call IS_ERR() rather than a NULL check.
> > > > 
> > > > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > > 
> > > Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > Applied, thanks.
> 
> In another thread, we were just talking about who clk_get() can
> return a NULL if !CONFIG_HAVE_CLK.  That might change to match the
> documentation later...  Not sure.

So what is the solution here? Will the dummy clk_get() be changed, or is
there more work needed on the drivers?

/me stifles a rant about the PTR_ERR pattern

g.
