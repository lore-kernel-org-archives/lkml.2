Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1CNQhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:37:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44785 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1CNQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
	<1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
	<AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
Date: Mon, 14 Mar 2011 17:37:14 +0100
Message-ID: <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Bibek BASU <bibek.basu@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 3:32 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> Grant can you have a look at this GPIO driver from a while back?
>
> Bibek can probably repost it if you don't have it in your archive...
>
> It'd be great if you could take this through the GPIO tree if/when
> it's OK with you.

Ping on this, the ux500-core tree is now sent to Russell for merging
into 2.6.39 so if possible I'd like to have this merged into the
GPIO tree (unless there are still review comments...) note
Samuel's ACK if you pick it.

Yours,
Linus Walleij
