Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2JHGUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:20:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57552 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2JHGUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <1349320509-26930-6-git-send-email-festevam@gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<1349320509-26930-6-git-send-email-festevam@gmail.com>
Date: Mon, 8 Oct 2012 08:20:44 +0200
Message-ID: <CACRpkdYTqT=eCOWq7hnymMVg0kab-pkXfv4kxnzSrNCNstpwJw@mail.gmail.com>
Subject: Re: [PATCH 6/6] gpio: gpio-da9052: Convert to the new da9052
 interrupt functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 5:15 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Convert to the new da9052 interrupt functions, so that we can get rid of
> irq_base references.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied to my GPIO tree with Mark's ACK.

Yours,
Linus Walleij
