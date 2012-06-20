Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2FTOrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:47:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52487 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2FTOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <1340202832-16850-1-git-send-email-stigge@antcom.de>
References: <1340202832-16850-1-git-send-email-stigge@antcom.de>
Date: Wed, 20 Jun 2012 11:46:58 -0300
Message-ID: <CAAAP30FE4TDczVBZE-cx6WB7f1KPOkf9iWBB-64DRb_97cLukg@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-lpc32xx: Add gpio_to_irq mapping
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 11:33 AM, Roland Stigge <stigge@antcom.de> wrote:
> This patch helps mapping with gpio_to_irq for the GPIOs that are irq enabled.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
