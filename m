Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2HaXTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:19:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57554 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:19:16 -0400
MIME-Version: 1.0
In-Reply-To: <1346153444.11862.1.camel@phoenix>
References: <1346153444.11862.1.camel@phoenix>
Date: Sat, 1 Sep 2012 01:19:15 +0200
Message-ID: <CACRpkdY8KnJp6PkKyuq-kVQdn3kZhH3fH_ujHcAXVnT1SBVxfg@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Fix checking return value of irq_alloc_descs
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 1:30 PM, Axel Lin <axel.lin@gmail.com> wrote:

> irq_alloc_descs() returns negative error code on failure.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied with Magnus' ACK.

Yours,
Linus Walleij
