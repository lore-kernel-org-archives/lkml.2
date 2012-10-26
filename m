Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2JZH0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:26:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55475 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab2JZH0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <1351162983-27723-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1351162983-27723-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 26 Oct 2012 09:26:33 +0200
Message-ID: <CACRpkdYPbs34Ob+MN9tjevXPTwGnEYsyJG0LMjCqsfxP=S_FJA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Don't return -EPROBE_DEFER to sysfs, or for
 invalid gpios
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 1:03 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> gpios requested with invalid numbers, or gpios requested from userspace via sysfs
> should not try to be deferred on failure.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Very good catch. I applied this to my fixes branch and also
put the stable tag on this thing, it goes way back to the introduction
of deffered probe.

Mark: OK with this?

Yours,
Linus Walleij
