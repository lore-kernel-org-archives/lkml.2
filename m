Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2LSQjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:39:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2LSQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:39:31 -0500
Date: Wed, 19 Dec 2012 19:39:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] spi: fix return value check in hspi_probe().
Message-ID: <20121219163914.GN5032@mwanda>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
 <1355271894-5284-6-git-send-email-tipecaml@gmail.com>
 <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com>
 <20121219151154.937EC3E0AD7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219151154.937EC3E0AD7@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:11:54PM +0000, Grant Likely wrote:
> On Tue, 11 Dec 2012 16:36:27 -0800 (PST), Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:
> > 
> > Hi
> > 
> > > According to its documentation, clk_get() returns a "valid IS_ERR() condition
> > > containing errno", so we should call IS_ERR() rather than a NULL check.
> > > 
> > > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > 
> > Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Applied, thanks.

In another thread, we were just talking about who clk_get() can
return a NULL if !CONFIG_HAVE_CLK.  That might change to match the
documentation later...  Not sure.

regards,
dan carpenter

