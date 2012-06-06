Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2FFDlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:41:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44037 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2FFDlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:41:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120529091757.GG30400@pengutronix.de>
References: <1337987696-31728-4-git-send-email-festevam@gmail.com>
	<1338048232-3523-1-git-send-email-festevam@gmail.com>
	<20120529091757.GG30400@pengutronix.de>
Date: Wed, 6 Jun 2012 00:41:17 -0300
Message-ID: <CAOMZO5AZ0mw7yDs6aBN4NP0K5jK-Ee6Yz6hfu5nhr6HXdNP_+A@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] hw_random: mxc-rnga: Use clk_prepare_enable/clk_disable_unprepare
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

On Tue, May 29, 2012 at 6:17 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, May 26, 2012 at 01:03:52PM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Prepare the clock before enabling it.
>>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: <linux-kernel@vger.kernel.org>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Can this be applied?
