Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2GEMiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:38:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62587 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2GEMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 5 Jul 2012 14:38:47 +0200
Message-ID: <CACRpkdYmCrwSXWGP_xLaF4a37EENWkz+Q1cCNqHcHJkNROnw1w@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Use irq_domain mappings for gpios
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 2:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> This has no practical impact at present since we don't support device tree
> so any user must have set an irq_base but this will in future allow a
> transition to device tree with minimal invasiveness.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Patch applied.

Thanks,
Linus Walleij
