Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2DCU3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:29:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61079 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2DCU3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1333055554-31300-12-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
	<1333055554-31300-12-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 3 Apr 2012 22:29:35 +0200
Message-ID: <CACRpkdZ7WPeT+rO-GLJvQ--fgdCG1ytwNAtvEq1g=b=5QxPvjQ@mail.gmail.com>
Subject: Re: [PATCH 12/17] gpio/samsung: mark const init data with __initconst
 instead of __initdata
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/29 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

> As long as there is no other non-const variable marked __initdata in the
> same compilation unit it doesn't hurt. If there were one however
> compilation would fail with
>
>        error: $variablename causes a section type conflict
>
> because a section containing const variables is marked read only and so
> cannot contain non-const variables.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
