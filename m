Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2K0HwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:52:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38916 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab2K0HwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:52:14 -0500
MIME-Version: 1.0
In-Reply-To: <50B4082C.5000104@gmail.com>
References: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com>
	<20121126202601.625213E0A04@localhost>
	<CACRpkdZo92OvNmBkqBYU+HgmtR5dmF5vFTaOYPdWr8rtZ3XT_g@mail.gmail.com>
	<50B4082C.5000104@gmail.com>
Date: Tue, 27 Nov 2012 08:52:13 +0100
Message-ID: <CACRpkdYs4K-+W0XNNH2vzCsXeXOGGvs2wXmO190ejoSCunvWhQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] irqdomain: augment add_simple() to allocate descs
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 1:24 AM, Rob Herring <robherring2@gmail.com> wrote:

> My objection was removing completely (which a pr_debug effectively
> does). I think Grant is saying just make the warning more informative
> about why it failed which is fine with me. nr_irqs is already printed
> out, so that provides some info already (although it is pretty terse).

OK sent a patch for this...

Yours,
Linus Walleij
