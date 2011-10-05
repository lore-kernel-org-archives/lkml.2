Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660Ab1JEOc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:32:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34391 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347Ab1JEOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <20111003155128.GN4118@sortiz-mobl>
References: <1313137670-30683-1-git-send-email-linus.walleij@stericsson.com>
	<20111003155128.GN4118@sortiz-mobl>
Date: Wed, 5 Oct 2011 16:32:55 +0200
Message-ID: <CACRpkdZ11ZDbPxR5DKcyva3Nu6uuRtTxi3Op55Ykr7OjzHCD3A@mail.gmail.com>
Subject: Re: [PATCH 03/23] mfd/db8500-prcmu: initialize DB8500 PRCMU regs
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:51 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:

>> +static void __init init_prcm_registers(void)
> Could we have a less generic function name here ?

OK I will rename it db8500_prcmu_init() as an add-on patch.

Yours,
Linus Walleij
