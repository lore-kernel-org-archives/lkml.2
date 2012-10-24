Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2JXIA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:00:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48344 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2JXIA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <1351022666-6960-44-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-44-git-send-email-keescook@chromium.org>
Date: Wed, 24 Oct 2012 10:00:55 +0200
Message-ID: <CACRpkdY6z=jbZ5d9XoD9dViT9dgZuEc8cqufyJ8yK20Z19kZvw@mail.gmail.com>
Subject: Re: [PATCH 043/193] drivers/gpio: remove CONFIG_EXPERIMENTAL
From: Linus Walleij <linus.walleij@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:01 PM, Kees Cook <keescook@chromium.org> wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

I will defer this to the senior GPIO subsystem maintainer who knows the
ways of the kernel summit, so I expect Grant to merge this patch if he
likes it.

Yours,
Linus Walleij
