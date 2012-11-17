Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2KQSl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:41:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37830 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2KQSl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <201211122044.13663.arnd@arndb.de>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
	<1352406191-14303-6-git-send-email-sasha.levin@oracle.com>
	<201211122044.13663.arnd@arndb.de>
Date: Sat, 17 Nov 2012 19:41:56 +0100
Message-ID: <CACRpkdZeM_FBGSa+UcH6GTK-Q7ekHbZO7Az7wQibfuFYqLFFhA@mail.gmail.com>
Subject: Re: [PATCH] ARM: integrator: use BUG_ON where possible
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 9:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>
> Linus Walleij is doing most of the integrator work these days, maybe he
> wants to apply the patch.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

OK I'll apply it to my stash and submit a pull request to
simplify things.

I could split this into its own topic but with noone else changing
anything orthogonally on the Integrator I don't know if it's really
worth it, probably it's just better to take the stuff I sent yesterday
and a patch I made this evening and request it all to be pulled
at once.

Yours,
Linus Walleij
