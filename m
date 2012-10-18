Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab2JRSfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:35:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50494 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2JRSfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
Date: Thu, 18 Oct 2012 20:35:29 +0200
Message-ID: <CACRpkdapB5x2MEKKvDU2MBKPVKXwYCx+HDYFUcY0vskeVOxPTg@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
        akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 8:18 PM, Bryan Wu <cooloney@gmail.com> wrote:

> Mutex lock is not safe in atomic context like the bug reported by
> Miles Lane:
(...)
> This patch replace mutex lock with spin lock which is safe for this case.
>
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Bryan Wu <cooloney@gmail.com>

Looks correct to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
