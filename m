Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2JOMh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:37:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39922 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2JOMhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <1350262125-25883-1-git-send-email-tfarina@chromium.org>
References: <1350262125-25883-1-git-send-email-tfarina@chromium.org>
Date: Mon, 15 Oct 2012 14:37:24 +0200
Message-ID: <CACRpkdaTE4Nfd5YX3N6LQ8piH4uyeYbckHh39SeNM9_tXdPWuQ@mail.gmail.com>
Subject: Re: [PATCH] power: remove duplicated include of abx500.h from ab8500_fb.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 2:48 AM, Thiago Farina <tfransosi@gmail.com> wrote:

> Signed-off-by: Thiago Farina <tfarina@chromium.org>

The subject of this patch and the empty commit blurb does not
describe what you're actually doing: you are also re-arranging all
the #include directives in alphabetic order, so please tell that
in the commit message.

Yours,
Linus Walleij
