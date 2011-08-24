Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1HXHqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:46:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37184 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HXHqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4w+dkzHbYBehEzgK2+Js=BmAYe2gHKQ1PtYc=ymhovnDQ@mail.gmail.com>
References: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4w+dkzHbYBehEzgK2+Js=BmAYe2gHKQ1PtYc=ymhovnDQ@mail.gmail.com>
Date: Wed, 24 Aug 2011 09:46:17 +0200
Message-ID: <CACRpkdYLJ9Dv1ZLmcPL6JtwmygNwn6QHTHtnn18PYuHSfveMSA@mail.gmail.com>
Subject: Re: [PATCH 2/4 v4] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 8:17 AM, Barry Song <21cnbao@gmail.com> wrote:

> Hi Linus,
> This patch can't compile....
> (...)
> Did you send the wrong version?

Apparently :-(

I have pinctrl_dev all over my code, not this old thing.

I'll mail out a v5 patch set this week, hold on...

Thanks for your detailed reviews!
Linus Walleij
