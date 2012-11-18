Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2KRMav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 07:30:51 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65315 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2KRMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 07:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121118042046.GA18226@lizard.sbx05977.paloaca.wayport.net>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<1349320509-26930-5-git-send-email-festevam@gmail.com>
	<20121118042046.GA18226@lizard.sbx05977.paloaca.wayport.net>
Date: Sun, 18 Nov 2012 10:30:49 -0200
Message-ID: <CAOMZO5B-fwMadjvRpLCTwvXZadhQCk8LcDWXQRXD3joiL9qBug@mail.gmail.com>
Subject: Re: [PATCH 5/6] power: da9052-battery: Convert to the new da9052
 interrupt functions
From: Fabio Estevam <festevam@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 2:20 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> It seems that the patch depends on other patches in this series.
>
> I don't see it linux-next, so if anything, for the drivers/power part:
>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks, Anton. Yes, the mfd patches still need to be applied by Samuel
so that all dependencies can be resolved.

Samuel?

Thanks,

Fabio Estevam
