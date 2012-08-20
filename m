Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2HTO1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:27:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38227 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2HTO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-7-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-7-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:27:05 +0200
Message-ID: <CACRpkdaWKf2se6PE7SMoOoqbTCLaMBMgjKbJa5tpQzr-RTSmJg@mail.gmail.com>
Subject: Re: [PATCH 06/11] ARM: mvebu: add pinctrl device in DT for Armada
 370/XP SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>
> The Armada 370 and XP SoCs have configurable muxing for a certain
> number of their pins, controlled through a pinctrl driver.
>
> The 'compatible' property is defined in the SoC-specific .dtsi files,
> since the compatible string identifies the number of pins and other
> SoC-specific properties.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

FWIW:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
