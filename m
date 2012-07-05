Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2GENYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:24:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42958 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2GENYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <1340684301-16836-1-git-send-email-olof@lixom.net>
References: <1340684301-16836-1-git-send-email-olof@lixom.net>
Date: Thu, 5 Jul 2012 15:24:50 +0200
Message-ID: <CACRpkdYTgMi=O76ZmkVxkXCkc4WnY9cu86oDvU_Oq2sZQhkCBw@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: add flags specifier to device-tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 6:18 AM, Olof Johansson <olof@lixom.net> wrote:

> This adds a flags field to the gpio specifier for Samsung. I didn't
> want to add yet another field in the already quite long specifier, so
> I decided to compress it together with the Pull Up/Down settings instead.
>
> This is needed to, for example, have a gpio-keys input that is active low.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied.

Thanks,
Linus Walleij
