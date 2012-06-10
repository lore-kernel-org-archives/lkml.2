Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2FJQjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 12:39:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38458 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2FJQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 12:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <1339113369-27045-1-git-send-email-swarren@wwwdotorg.org>
References: <1339113369-27045-1-git-send-email-swarren@wwwdotorg.org>
Date: Sun, 10 Jun 2012 18:39:15 +0200
Message-ID: <CACRpkdYxTs8sbBfVFL3Et4T3hgXfnUQ_7th8byC+TUGHu4RC7Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: export devm_gpio_request_one
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 1:56 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Without this, modules can't use this API, leading to build failures.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
