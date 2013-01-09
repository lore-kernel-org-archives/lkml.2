Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3AIFXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:23:04 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:59623
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3AIFXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:23:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 9 Jan 2013 13:50:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] clk: mxs: Index is always positive
Message-ID: <20130109055017.GA12525@S2100-06.ap.freescale.net>
References: <1357609135-13922-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1357609135-13922-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:38:55PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following warnings when building with W=1 option:
> 
> drivers/clk/mxs/clk-imx23.c: In function 'mx23_clocks_init':
> drivers/clk/mxs/clk-imx23.c:149:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/clk/mxs/clk-imx23.c:165:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> ...
> 
> drivers/clk/mxs/clk-imx28.c: In function 'mx28_clocks_init':
> drivers/clk/mxs/clk-imx28.c:227:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/clk/mxs/clk-imx28.c:244:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

