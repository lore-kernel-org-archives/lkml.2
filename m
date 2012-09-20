Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2ITGtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:49:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39993 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2ITGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <5059E1DA020000780009C53D@nat28.tlf.novell.com>
References: <5059E1DA020000780009C53D@nat28.tlf.novell.com>
Date: Thu, 20 Sep 2012 08:49:03 +0200
Message-ID: <CACRpkdYamf9SG-Ugx78kyuoVSzqELzLJ23XkqOi-UkgczNkPxA@mail.gmail.com>
Subject: Re: [PATCH, v2] allow gpiolib to be a module
From: Linus Walleij <linus.walleij@linaro.org>
To: Jan Beulich <JBeulich@suse.com>, Grant Likely <grant.likely@secretlab.ca>
Cc: Ryan Mallon <rmallon@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 3:16 PM, Jan Beulich <JBeulich@suse.com> wrote:

> Without ARCH_REQUIRE_GPIOLIB there's no reason to force this code, when
> enabled, to always be built into the kernel, which requires only minor
> Makefile and source code adjustments.
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
>
> ---
> v2: Make gpiolib_init() static. Properly handle !CONFIG_DEBUG_FS case.

This is looking better to me indeed, but I definately want Grant's
consent before mergeing this, not just as primary GPIO maintainer,
but also since he's been looking a lot more into module dependencies
lately.

Ping on Grant...

Yours,
Linus Walleij
