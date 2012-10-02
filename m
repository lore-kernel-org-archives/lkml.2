Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2JBFc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:32:28 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:43128 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab2JBFc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:32:26 -0400
Date: Tue, 2 Oct 2012 09:32:23 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, festevam@gmail.com
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new
 clock framework
Message-ID: <20121002053223.GA20786@ioremap.net>
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
 <5069D830.6070307@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069D830.6070307@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:51:44PM -0300, Fabio Estevam (fabio.estevam@freescale.com) wrote:
> Evgeny,
> 
> Any comments, please?

I have no objections per se, but I'm hardly an expert in imx clock
framework :)

Since it is only one patch in set of 3, I suppose it will be pushed
through different tree than w1. Feel free to add my ack.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
