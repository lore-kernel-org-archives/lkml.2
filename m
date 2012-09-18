Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2IRVWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:22:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46916 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2IRVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347976433-1176-1-git-send-email-stigge@antcom.de>
References: <1347976433-1176-1-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 23:22:28 +0200
Message-ID: <CACRpkdacODp0QTiZyBX46Bm61_98QN=X+GJJ7G44AXx9Eq2BHw@mail.gmail.com>
Subject: Re: [PATCH v2] spi/pl022: Devicetree support w/o platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 3:53 PM, Roland Stigge <stigge@antcom.de> wrote:

> Even with devicetree support, we needed platform data to provide some data,
> leading to mixed device tree and platform data. This patch makes it possible to
> provide all that information via device tree. Now, the data must be provided
> via platform data _or_ device tree completely.
>
> Only in case of DMA where a callback specification is necessary (dma_filter()),
> platform data is the only option.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
