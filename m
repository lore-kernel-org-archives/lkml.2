Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2FKVBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:01:48 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58120 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2FKVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:01:47 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-7-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-7-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:01:46 +0200
Message-ID: <CACRpkdYoQFhBfRaPMBiVTiD979b+8708oS1qCPm+iyy5OZe2bw@mail.gmail.com>
Subject: Re: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at
 core_initcall time
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, grant.likely@secretlab.ca
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:24 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now the AB8500 has its own IRQ domain

But that does not appear until patch 8 in this series? Are the patches in
the wrong order? Or does this need rewording?

> it needs to be initialised earlier
> in the boot sequence. As the AB8500 relies on the DB8500 PRCMU we need to
> reflect this change for the PRCMU driver too.

Hm what shall we do when we run out of initlevels? I think this was the
kind of thing that deferred probe should solve. Usually changing this kind
of thing has side effects so I'm a bit hesitant.

Yours,
Linus Walleij
