Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2HNIdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:33:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33662 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2HNIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <1344527828-6283-2-git-send-email-lee.jones@linaro.org>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
	<1344527828-6283-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:33:09 +0200
Message-ID: <CACRpkdbaXHqPUDYFHWgMwu-g3kHyZsHWvGq3_dR_wjQddgeUoA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Remove unused snowball_of_platform_devs struct
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This was left over during a recent clean-up which removed Device Tree
> helper structs. There is no longer a requirement for it, so we can just
> remove it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
