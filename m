Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2HNLS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:18:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50745 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2HNLS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-18-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-18-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:18:55 +0200
Message-ID: <CACRpkdayCNFq9_evUdyNTuXaJacnk1sHqOqebnOgvLYhYqxj8Q@mail.gmail.com>
Subject: Re: [PATCH 17/22] ARM: ux500: Remove platform registration of MSP devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch removes platform device registration of all 4 MSP
> devices. It also takes care of all redundant infrastructure now
> that each of the ux500 audio components have been Device Tree
> enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

NOTE: it seems this patch set contains some churn. First you
add in the forked device init, put in a big chunk of code and
then in the *same* patch set delete it again. It's not like
we're dying to see all the development history... can this
be squashed down a bit?

Yours,
Linus Walleij
