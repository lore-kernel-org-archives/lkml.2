Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab2EKVWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:22:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51170 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab2EKVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120511174112.D9EEE3E0791@localhost>
References: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
	<20120511174112.D9EEE3E0791@localhost>
Date: Fri, 11 May 2012 23:22:40 +0200
Message-ID: <CACRpkdatENc_i2yyqiQiKScmNVWPujRC2MBoCsHa1VmTVV5xOQ@mail.gmail.com>
Subject: Re: [PATCH] gpio/msm-v1: re-read IRQ flags on each iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 7:41 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 11 May 2012 14:07:12 +0200, Linus Walleij <linus.walleij@stericsson.com> wrote:

> I'll need an ack from an msm developer before applying this.

Yep I forward it to David Brown when I realized I forgot him in the Cc...

Yours,
Linus Walleij
