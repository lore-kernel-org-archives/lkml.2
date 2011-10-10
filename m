Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1JJLIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:08:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34318 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1JJLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20111010102917.GK3686@sortiz-mobl>
References: <1317833447-714-1-git-send-email-linus.walleij@stericsson.com>
	<CACRpkdY=u2mmOZSeJRFvBbRyLwkbpKxSzKPx9gu-i8416KK5jQ@mail.gmail.com>
	<20111010102917.GK3686@sortiz-mobl>
Date: Mon, 10 Oct 2011 13:08:21 +0200
Message-ID: <CACRpkda2kxLMnEm1tQjb7d8Nn+hrJj3=TOOx=Qq75695uKBNMg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd/db8500-prcmu: rename init function
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:29 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:

>> I can also prepare a pull request for the stuff you want if it makes
>> things easier for you, just tell me what you want in it.
>
> I took the first 12 patches plus your 2 review fixes. I indeed feel the rest
> of the patchset would need some additional work. If there's really nothing we
> can do about factorizing more of this code between 8500 and 5500, then I'll
> look at it for the 3.3 merge window.

OK seems like a fair deal. I have different ideas, like for example
abstracting the MBOX parts into a new mailbox subsystem since
abstracting mailboxes has been discussed before. So maybe we can
break out all of that code into drivers/mbox and proceed from
there getting pure MFD arbiters in drivers/mfd.

Yours,
Linus Walleij
