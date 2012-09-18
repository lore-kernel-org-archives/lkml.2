Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2IRVVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:21:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53176 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2IRVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <1347973228-29839-1-git-send-email-stigge@antcom.de>
References: <1347973228-29839-1-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 23:20:57 +0200
Message-ID: <CACRpkdbchKn4Od7PJD83J1rxWayrUaavXP8Afx+M0RQuzEmbPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: LPC32xx: DTS update for devicetree completion of spi-pl022
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        arnd@arndb.de, devicetree-discuss@lists.ozlabs.org,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 3:00 PM, Roland Stigge <stigge@antcom.de> wrote:

> spi-pl022 got a further update to its devicetree support, completing properties
> such that no platform data is necessary anymore. This patch adjusts
> lpc32xx.dtsi accordingly.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

FWIW Acked-by: Linus Walleij <linus.walleij@linaro.org>
on both patches...

Yours,
Linus Walleij
