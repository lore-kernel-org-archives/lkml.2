Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2HNLMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:12:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53857 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2HNLMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-12-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-12-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:12:36 +0200
Message-ID: <CACRpkdbYD8vr_bk1=YfkQ9Yv1Hns5Etvdqf-ZYtKjYQC6-db=w@mail.gmail.com>
Subject: Re: [PATCH 11/22] ARM: ux500: Clean-up MSP platform code
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ola LILJA2 <ola.o.lilja@stericsson.com>,
        Ola Lilja <olalilja@yahoo.se>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch contains a couple of general MSP clean-ups pertaining to
> layout changes and changing functions to be void instead of int instead
> of regardlessly returning '0'.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

OK with me but also want Ola to look at this one.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
