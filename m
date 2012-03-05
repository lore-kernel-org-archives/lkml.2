Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2CEKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:06:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab2CEKGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:06:37 -0500
MIME-Version: 1.0
In-Reply-To: <1330907657-2156-3-git-send-email-paul.gortmaker@windriver.com>
References: <1330907657-2156-1-git-send-email-paul.gortmaker@windriver.com>
	<1330907657-2156-3-git-send-email-paul.gortmaker@windriver.com>
Date: Mon, 5 Mar 2012 11:06:36 +0100
Message-ID: <CACRpkdYpj4mvNfsA9bSEPLrehJ-0ydiyREuX+W2fyq0vnV1wtQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] device.h: audit and cleanup users in main include dir
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 1:34 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> The <linux/device.h> header includes a lot of stuff, and
> it in turn gets a lot of use just for the basic "struct device"
> which appears so often.
(...)
>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Why not...
Acked-by: Linus Walleij <linus.walleij@linaro.org>

(For pl022, ab5x00)

Thanks,
Linus Walleij
