Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1CNKQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:16:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1CNKQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:16:32 -0400
Date: Mon, 14 Mar 2011 11:16:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110314101612.GD28960@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <1299134429.100626.661279191478.0.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299134429.100626.661279191478.0.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:40:29PM +0800, Jeremy Kerr wrote:
> Hi all,
> 
> These patches are an attempt to allow platforms to share clock code. At
> present, the definitions of 'struct clk' are local to platform code,
> which makes allocating and initialising cross-platform clock sources
> difficult, and makes it impossible to compile a single image containing
> support for two ARM platforms with different struct clks.
> 
> The three patches are for the architecture-independent kernel code,
> introducing the common clk infrastructure. The changelog for the first
> patch includes details about the new clock definitions.
> 
> Many thanks to the following for their input:
>  * Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  * Ben Dooks <ben-linux@fluff.org>
>  * Baruch Siach <baruch@tkos.co.il>
>  * Russell King <linux@arm.linux.org.uk>
>  * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>  * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
>  * Vincent Guittot <vincent.guittot@linaro.org>
>  * Sascha Hauer <s.hauer@pengutronix.de>
>  * Ryan Mallon <ryan@bluewatersys.com>
>  * Colin Cross <ccross@google.com>
>  * Jassi Brar <jassisinghbrar@gmail.com>
>  * Saravana Kannan <skannan@codeaurora.org>

Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

who is responsible to take this patch?  Russell?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
