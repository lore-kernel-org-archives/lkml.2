Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2HCPKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:10:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60503 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2HCPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:10:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120731064053.GW30009@pengutronix.de>
References: <1343407672-27185-1-git-send-email-fabio.estevam@freescale.com>
	<20120731064053.GW30009@pengutronix.de>
Date: Fri, 3 Aug 2012 12:10:28 -0300
Message-ID: <CAOMZO5BSi7sfK+4mjPUn9j89CssyGBJkLXY_0aDekA5SRrXD-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx
 clock framework
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "Theodore Ts'o" <tytso@mit.edu>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

On Tue, Jul 31, 2012 at 3:40 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Jul 27, 2012 at 01:47:51PM -0300, Fabio Estevam wrote:
>> Adapt clocks to the new i.mx clock framework and fix the following warning:
>>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: <linux-kernel@vger.kernel.org>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Both:
>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Looks like git did not Cc'ed you in these patches.

Would it be OK to apply these two patches?

Thanks,

Fabio Estevam
