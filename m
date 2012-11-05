Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2KENbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:31:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2KENbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:31:31 -0500
MIME-Version: 1.0
In-Reply-To: <1352121830.14769.2.camel@phoenix>
References: <1352121830.14769.2.camel@phoenix>
Date: Mon, 5 Nov 2012 14:31:29 +0100
Message-ID: <CACRpkdYpL+c5hw3O2K2r3O_vftZPWfdd8CzACRCvdKRXAmneKQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:23 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Merged to my AT91 branch, unless Jean-Christophe says something...

Thanks!
Linus Walleij
