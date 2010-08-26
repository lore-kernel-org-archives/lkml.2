Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0HZXHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:07:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab0HZXHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:07:45 -0400
Date: Thu, 26 Aug 2010 16:07:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, dtor@mail.ru,
        adobriyan@gmail.com, tj@kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] UCB1400: Pass ucb1400-gpio data through ac97 bus
Message-Id: <20100826160736.747f3717.akpm@linux-foundation.org>
In-Reply-To: <201008090643.14777.marek.vasut@gmail.com>
References: <1281327394-6716-1-git-send-email-marek.vasut@gmail.com>
	<201008090643.14777.marek.vasut@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010 06:43:14 +0200
Marek Vasut <marek.vasut@gmail.com> wrote:

> Dne Po 9. srpna 2010 06:16:34 Marek Vasut napsal(a):
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Please don't send unchangelogged patches.

The title tells us what the patch does but provides no hint as to why
it does it.

> > ---
> >  drivers/gpio/ucb1400_gpio.c |   19 ++++++-------------
> >  drivers/mfd/ucb1400_core.c  |    5 +++++
> >  include/linux/ucb1400.h     |   19 ++++++-------------
> >  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> Ah right, guys, if possible, let this go through Eric Miao's tree (as I have 
> changes that depend on this). Thanks!

He's probably unaware of the patch.  Let's cc him.
