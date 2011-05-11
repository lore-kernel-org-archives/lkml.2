Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1EKQpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:45:16 -0400
Received: from void.printf.net ([89.145.121.20]:52754 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1EKQpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:45:12 -0400
From: Chris Ball <cjb@laptop.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v4] sdio: optimized SDIO IRQ handling for single irq
References: <1305100416-5395-1-git-send-email-per.forlin@linaro.org>
Date: Wed, 11 May 2011 10:40:13 -0400
In-Reply-To: <1305100416-5395-1-git-send-email-per.forlin@linaro.org> (Per
	Forlin's message of "Wed, 11 May 2011 09:53:35 +0200")
Message-ID: <m3d3jp2tde.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

On Wed, May 11 2011, Per Forlin wrote:
> Optimize performance for single irq
>
> Changes since v2.
>  * Rebase on mmc-next, change of line numbers no code changes.
>
> Stefan Nilsson XK (1):
>   sdio: optimized SDIO IRQ handling for single irq
>
>  drivers/mmc/core/sdio_irq.c |   33 ++++++++++++++++++++++++++++++++-
>  include/linux/mmc/card.h    |    1 +
>  2 files changed, 33 insertions(+), 1 deletions(-)

Odd, still doesn't apply here:

error: patch failed: drivers/mmc/core/sdio_irq.c:42
error: drivers/mmc/core/sdio_irq.c: patch does not apply

patch -p1 says:
Hunk #2 succeeded at 53 with fuzz 1.

So this still isn't rebased onto mmc-next properly.  There haven't been
any changes to drivers/mmc/core/sdio_irq.c since 2008, though, so now
I'm wondering where you got the fuzz from..

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
