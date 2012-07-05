Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2GEMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:46:44 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56736 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2GEMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <1339113369-27045-1-git-send-email-swarren@wwwdotorg.org>
References: <1339113369-27045-1-git-send-email-swarren@wwwdotorg.org>
Date: Thu, 5 Jul 2012 14:46:40 +0200
Message-ID: <CACRpkdajdvCdurws6am5QpNru02FtHaQjycf4mxCVcBzhdS7JA@mail.gmail.com>
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

Applied.

Thanks,
Linus Walleij
