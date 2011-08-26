Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1HZIgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:36:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38978 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1HZIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yGSJPDiywak=ArMSv6DUKyCRAZ2J1Fxj6ZKgryyMzu8g@mail.gmail.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4yGSJPDiywak=ArMSv6DUKyCRAZ2J1Fxj6ZKgryyMzu8g@mail.gmail.com>
Date: Fri, 26 Aug 2011 10:36:34 +0200
Message-ID: <CACRpkdbWQ3Zz5cn3Bt9K3Le6FmFmAqqPEjj8CP_Pt8m9bG4Opg@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 5:12 AM, Barry Song <21cnbao@gmail.com> wrote:

> Tested-by: Barry Song <baohua.song@csr.com>

Thanks!

> Linus, i'll also send the patch of csr pinmux prototype. you might
> review and take it as another example except your stericsson U300 and
> take care while you merge pinmux.

OK I'm modifying the data model to suit Stephen and Sachas
remarks but I might be able to carry your mux driver along too.

Yours,
Linus Walleij
