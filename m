Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2JCH2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:28:19 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:56167 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab2JCH2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:28:18 -0400
Date: Wed, 3 Oct 2012 11:28:15 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new
 clock framework
Message-ID: <20121003072815.GA1590@ioremap.net>
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
 <5069D830.6070307@freescale.com>
 <20121002053223.GA20786@ioremap.net>
 <CAOMZO5Aun8OMKY0wPm9TZfyqWwCNGa7xvWyR7W-bzwG_=1iecQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Aun8OMKY0wPm9TZfyqWwCNGa7xvWyR7W-bzwG_=1iecQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 10:04:19PM -0300, Fabio Estevam (festevam@gmail.com) wrote:
> > I have no objections per se, but I'm hardly an expert in imx clock
> > framework :)
> >
> > Since it is only one patch in set of 3, I suppose it will be pushed
> > through different tree than w1. Feel free to add my ack.
> >
> > Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> Could this series go via your tree?

Please send it to Greg (added to CC), but I would like someone who knows
this platform (and not only w1 bits, which look good) to acknowledge changes,
feel free to add mine.

-- 
	Evgeniy Polyakov
