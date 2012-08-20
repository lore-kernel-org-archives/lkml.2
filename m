Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2HTO03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:26:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54749 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2HTO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-6-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:26:24 +0200
Message-ID: <CACRpkdaP10PBREYO4OLvzCeKQLctup6+Upty4GWRzRZwsa+ReA@mail.gmail.com>
Subject: Re: [PATCH 05/11] pinctrl: mvebu: add pinctrl driver for Armada XP
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
> This pinctrl driver is not a full-blown pinctrl driver from scratch:
> it relies on the common pinctrl-mvebu driver, which is used for all
> Marvell EBU SoCs.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Same comments as on the previous driver, no further comments,
and looking good.

Yours,
Linus Walleij
