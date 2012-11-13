Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2KMObR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:31:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58533 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2KMObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:31:16 -0500
MIME-Version: 1.0
In-Reply-To: <1352702020.15066.2.camel@phoenix>
References: <1352702020.15066.2.camel@phoenix>
Date: Tue, 13 Nov 2012 15:31:13 +0100
Message-ID: <CACRpkdbE+GdUP4DHQvrD3YitUkizSxe=4X8HbcLL0a3AfxD4qw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Drop selecting PINCONF for MMP2, PXA168 and PXA910
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 7:33 AM, Axel Lin <axel.lin@ingics.com> wrote:
> These drivers do not need to select PINCONF.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

I'm a bit uncertain as to why they still select PINCONF, Haojian
can you check this patch before I apply it?

Yours,
Linus Walleij
