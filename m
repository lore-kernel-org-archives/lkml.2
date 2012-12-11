Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2LKNUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:20:32 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:12615
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab2LKNUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:20:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I179dN1432Izz1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 11 Dec 2012 21:20:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] clk: mxs: Remove unneeded NULL pointer check
Message-ID: <20121211132037.GC10128@S2101-09.ap.freescale.net>
References: <1353533583-13166-1-git-send-email-festevam@gmail.com>
 <CAOMZO5BDkX2s+wK7d_KQPZbAvraM4vhcH93d_DsquTAw7tJ+vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5BDkX2s+wK7d_KQPZbAvraM4vhcH93d_DsquTAw7tJ+vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:33:34AM -0200, Fabio Estevam wrote:
> Shawn/Mike,
> 
> On Wed, Nov 21, 2012 at 7:33 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> >
> > mxs platform has been converted to device tree.
> >
> > There is no need to check if np is NULL after doing:
> >
> > np = of_find_compatible_node(NULL, NULL, "fsl,imx[23/28]-clkctrl");
> >
> > ,as it will always be non-NULL.
> >
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Does this patch look good?

Hmm, technically the check is still valid, as np can be NULL if
the clkctrl node with correct compatible string is not present.

Shawn

