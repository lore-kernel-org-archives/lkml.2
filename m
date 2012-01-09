Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2AIURi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:17:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32997 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab2AIURh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:17:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120109190827.GB9440@kroah.com>
References: <20120109190827.GB9440@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 12:17:15 -0800
X-Google-Sender-Auth: JLtZmczyDVp-HoH6bLhybhK42nw
Message-ID: <CA+55aFxjj0Bji2ivUPc7g5E0bz7Gft7a9uNbeDP4aQABhgTwng@mail.gmail.com>
Subject: Re: [GIT PATCH] big staging merge for 3.3
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 11:08 AM, Greg KH <greg@kroah.com> wrote:
>
> Note, you will get a merge conflict in the
> drivers/staging/iio/adc/ad799x_core.c file, but it's pretty simple to
> resolve (just delete the module_init/exit calls, and keep the
> MODULE_ALIAS line).

Are you sure about keeping the MODULE_ALIAS line?

It was removed by commit 55e4390cb04e ("staging:iio: Add missing
MODULE_DEVICE_TABLE and MODULE_ALIAS") which added the
MODULE_DEVICE_TABLE() line for that driver instead.

The natural merge would seem to be to remove that line too.

                        Linus
