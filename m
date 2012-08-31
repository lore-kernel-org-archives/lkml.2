Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2HaAFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:05:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59254 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2HaAFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <1346153444.11862.1.camel@phoenix>
References: <1346153444.11862.1.camel@phoenix>
Date: Thu, 30 Aug 2012 17:05:02 -0700
Message-ID: <CACRpkdbbMiCZKf_FAph=g-BL9-AXGhkdxC=2mv01xANt8KiNoQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Fix checking return value of irq_alloc_descs
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>, Magnus Damm <damm@opensource.se>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 4:30 AM, Axel Lin <axel.lin@gmail.com> wrote:

> irq_alloc_descs() returns negative error code on failure.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Magnuis can I have your ACK on this?

Yours,
Linus Walleij
