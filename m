Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2FDQ60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:58:26 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61774 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2FDQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <1338557791-6588-1-git-send-email-dbaryshkov@gmail.com>
References: <1338557791-6588-1-git-send-email-dbaryshkov@gmail.com>
Date: Mon, 4 Jun 2012 18:58:23 +0200
Message-ID: <CACRpkdZ0hV5zPPrf-2VFqxUE+2Pb+UA-9bWeZNkaoN-sbizVoQ@mail.gmail.com>
Subject: Re: [PATCH][V3] gpio: add a driver for GPIO pins found on AMD-8111
 south bridge chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 3:36 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:

> Add a driver to use GPIO pins available on several AMD south bridges
> (currently only AMD 8111 is supported).
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

This v3 version looks good to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
