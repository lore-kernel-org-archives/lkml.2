Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0GDP4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:56:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36231 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab0GDP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oFNLtGege5R0NrQfLpLMMcZ6OhlBV1xc/m2kGrW3oiIHKEDsPSaAVZrC709BrU9GQ6
         OinCgx+Ce8DWlLNwHpJypUZcJAPXxa2A/4iQKMp06NKDNscyHPCcblwEYgEfSa9pgpd4
         nIFvU98CVxaPvI08r9DI4Ovn6+Ohd0Fb/ztXI=
MIME-Version: 1.0
In-Reply-To: <AANLkTikeR3hzF8KGBxPoRTiAmXXK62UB4CZ4t8tctC5_@mail.gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de> <daefd019d1a302665a0cc5817ed50cfb4b7b1c44.1277911346.git.siccegge@cs.fau.de> 
	<AANLkTikeR3hzF8KGBxPoRTiAmXXK62UB4CZ4t8tctC5_@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 4 Jul 2010 23:55:56 +0800
Message-ID: <AANLkTimhzM9N77oezsWoWk_lmDvpLnzrZBmW5KLcoR9C@mail.gmail.com>
Subject: Re: [PATCH 23/33] Removing dead BACKLIGHT_CORGI
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 11:50 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 12:01 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> BACKLIGHT_CORGI doesn't exist in Kconfig, therefore removing all
>> references for it from the source code.
>>
>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>
> BACKLIGHT_CORGI was renamed to BACKLIGHT_GENERIC in commit
> d00ba726725c6f41e43df00f83e484ba8f9fac5c.
>
> Since it's now safe to completely transition to LCD_CORGI, which not only
> includes the backlight functionality but also the LCD, so
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>

Applied.
