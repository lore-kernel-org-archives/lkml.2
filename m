Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1FBFTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:19:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59860 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab1FBFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:19:10 -0400
MIME-Version: 1.0
X-Originating-IP: [230.229.188.175]
In-Reply-To: <1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
	<1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
Date: Wed, 1 Jun 2011 22:19:09 -0700
Message-ID: <BANLkTikJWRUNBnMX0gji8_H30g4BodRvrw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
From: Olof Johansson <olof@lixom.net>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, arnd@arndb.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 8:33 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> It migrates mx1/mx21/mx25/mx27/mx31/mx35 gpio driver to
> drivers/gpio/gpio-mxc.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Olof Johansson <olof@lixom.net>
