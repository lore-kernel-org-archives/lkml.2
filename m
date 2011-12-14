Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1LNQBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:01:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47198 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:01:10 -0500
MIME-Version: 1.0
In-Reply-To: <1323878622-26602-3-git-send-email-b29396@freescale.com>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-3-git-send-email-b29396@freescale.com>
Date: Wed, 14 Dec 2011 14:01:09 -0200
Message-ID: <CAOMZO5DVsk_iNCrMaBbK4kuehhL1C71fKqC65isybJDknzWrRQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
From: Fabio Estevam <festevam@gmail.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, shawn.guo@freescale.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 2:03 PM, Dong Aisheng <b29396@freescale.com> wrote:

> +config PINMUX_IMX53
> +       bool "IMX53 pinmux driver"
> +       depends on ARCH_MX5

Shouldn't this be SOC_IMX53 instead?

Regards,

Fabio Estevam
