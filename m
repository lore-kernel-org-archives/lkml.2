Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2HNIGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:06:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55247 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2HNIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:06:50 -0400
MIME-Version: 1.0
In-Reply-To: <5029F8F6.1080207@samsung.com>
References: <5029F8F6.1080207@samsung.com>
Date: Tue, 14 Aug 2012 10:06:49 +0200
Message-ID: <CACRpkdYNKxjRXC=4no0p55ADkUvXTEcfW3b2z+Exg=cpHCtAAQ@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: card: Skip secure option for MoviNAND.
From: Linus Walleij <linus.walleij@linaro.org>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 9:06 AM, IAN CHEN <ian.cy.chen@samsung.com> wrote:

> +#define MMC_QUIRK_SECURE_MODE_BROKEN (1<<10)   /* Skip secure for
> erase/trim */

OK this will work and sorry for being picky, but we are working with RPMB
support and that's some other "secure mode" so to avoid any
misuderstandings it's better to name the flag like I proposed,
MMC_QUIRK_SEC_ERASE_TRIM_BROKEN

I won't die if this goes in though :-)

Yours,
Linus Walleij
