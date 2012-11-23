Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2KWPyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:54:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38959 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2KWPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
Date: Fri, 23 Nov 2012 16:54:09 +0100
Message-ID: <CAPDyKFq+MBo2338SiAF-mdDHpgTDJ0p6k2BaicJpSutGqtaubA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Input: nomadik-ske-keypad - clk fixups
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 November 2012 15:20, Ulf Hansson <ulf.hansson@stericsson.com> wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> Due to the convert to the common clk driver these changes for clks are needed.
>
> Ulf Hansson (2):
>   Input: nomadik-ske-keypad - fixup use of clk
>   Input: nomadik-ske-keypad - start using the apb_pclk
>
>  drivers/input/keyboard/nomadik-ske-keypad.c |   34 +++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 5 deletions(-)
>
> --
> 1.7.10
>

Just a kind reminder here. Do we see any issues with merging this?

Kind regards
Ulf Hansson
