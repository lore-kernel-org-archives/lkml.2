Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab2HHNSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:18:18 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55177 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab2HHNSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <50226409.1060800@de.bosch.com>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	<1344430493-5304-7-git-send-email-arnd@arndb.de>
	<CAOMZO5CZ7mJd89cN_S0KBS74mc5qTzvrfRbmHVX3nmEakx19ow@mail.gmail.com>
	<50226409.1060800@de.bosch.com>
Date: Wed, 8 Aug 2012 10:18:15 -0300
Message-ID: <CAOMZO5BtStkEWGRWi7LcVT_DK0C2WnjPiCOh2ZriVzrP+1NW3g@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: imx: gpmi-nand depends on mxs-dma
From: Fabio Estevam <festevam@gmail.com>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        artem.bityutskiy@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 10:05 AM, Dirk Behme <dirk.behme@de.bosch.com> wrote:

> Yes. But it seems it's not handled there? I'm trying since ~2 weeks to get
> something like your patch applied to get the broken mainline fixed, but
> unfortunately without success so far.

Let's try once again.

Artem,

Could https://patchwork.kernel.org/patch/1236551/ be applied?

Thanks,

Fabio Estevam
