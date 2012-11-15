Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993367Ab2KOLRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:17:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53254 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993327Ab2KOLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <1352823374.10676.1.camel@phoenix>
References: <1352823374.10676.1.camel@phoenix>
Date: Thu, 15 Nov 2012 12:17:36 +0100
Message-ID: <CACRpkdZyN6k5CrS8ufnwLCWm30gf6U3b4T7D6-U5yXAdvLFxcQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: coh901: Return proper error if
 irq_domain_add_linear() fails
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 5:16 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Return -ENOMEM instead of 0 if irq_domain_add_linear fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks!

Yours,
Linus Walleij
