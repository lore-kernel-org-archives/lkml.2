Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab2IJPn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:43:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53226 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab2IJPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <1347266386-16229-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-6-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Sep 2012 08:43:50 -0700
Message-ID: <CACRpkdY7HpW_DCUfQtcZ9MuKTRmc9B1Ja67GcftFszOkRK_KFA@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] pinctrl: mvebu: add pinctrl driver for Armada XP
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 1:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>
> This pinctrl driver is not a full-blown pinctrl driver from scratch:
> it relies on the common pinctrl-mvebu driver, which is used for all
> Marvell EBU SoCs.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
> v2: replaced variant with enum and used bitops.h

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
