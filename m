Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3AJLPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:15:54 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37243 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3AJLPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <1357493688-25061-3-git-send-email-gregory.clement@free-electrons.com>
References: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
	<1357493688-25061-3-git-send-email-gregory.clement@free-electrons.com>
Date: Thu, 10 Jan 2013 12:15:53 +0100
Message-ID: <CACRpkdYu63TZDpHrGkg0cdqFCrVH1PiNFX8FcrxB9S_Vk9r=kg@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: pca953x: add support for pca9505
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 6:34 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> Now that pca953x driver can handle GPIO expanders with more than 32
> bits this patch adds the support for the pca9505 which cam with 40
> GPIOs.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Applied, thanks.

Yours,
Linus Walleij
