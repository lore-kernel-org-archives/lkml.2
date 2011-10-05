Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab1JEQ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:59:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61506 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab1JEQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <1317833447-714-1-git-send-email-linus.walleij@stericsson.com>
References: <1317833447-714-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 5 Oct 2011 18:59:01 +0200
Message-ID: <CACRpkdY=u2mmOZSeJRFvBbRyLwkbpKxSzKPx9gu-i8416KK5jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd/db8500-prcmu: rename init function
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 6:50 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> This renames the PRCMU clock force initialization function
> to have a less generic name.

So these are fixing the review comments, if you prefer me to squash
them into the other patches just tell me.

I can also prepare a pull request for the stuff you want if it makes
things easier for you, just tell me what you want in it.

Yours,
Linus Walleij
