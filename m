Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2CZGnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:43:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62561 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2CZGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:43:00 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120326063956.GB24023@pengutronix.de>
References: <1332739713.15735.1.camel@phoenix> <20120326063956.GB24023@pengutronix.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 26 Mar 2012 14:42:39 +0800
Message-ID: <CAF+7xW=TRcW_2AFtDHBP4Dw3QBf0_mvecMO3g+Hqsk1xV8UC9Q@mail.gmail.com>
Subject: Re: [PATCH] watchdog: Make TXX9_WDT select WATCHDOG_CORE
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Ralf Baechle <ralf@linux-mips.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
>
> Can we simply fold this into the original patch?
Wim already applied the original patch.
I found this build error while compiling with today's linux-next.
So I think this need to be a separate patch.

Regards,
Axel
