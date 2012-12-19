Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2LSPMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:12:05 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38880 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2LSPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:11:58 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/5] spi: fix return value check in hspi_probe().
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Cyril Roelandt <tipecaml@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com> <1355271894-5284-6-git-send-email-tipecaml@gmail.com> <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com>
Date: Wed, 19 Dec 2012 15:11:54 +0000
Message-Id: <20121219151154.937EC3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012 16:36:27 -0800 (PST), Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:
> 
> Hi
> 
> > According to its documentation, clk_get() returns a "valid IS_ERR() condition
> > containing errno", so we should call IS_ERR() rather than a NULL check.
> > 
> > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> 
> Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Applied, thanks.

g.

