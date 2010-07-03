Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0GCU65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 16:58:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0GCU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 16:58:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: catch up on various minor cleanups.
Date: Sat, 3 Jul 2010 22:58:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201007030218.o632I2uv004036@farm-0002.internal.tilera.com>
In-Reply-To: <201007030218.o632I2uv004036@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007032258.48606.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/uIIktBvCtsoDZvYUSKovLznwnlLK7ULX1erf
 zv2U2bKtGRnW2NcrQ3OgqqQbqH0lT0ZHGLJVxqexbBfWENHtLD
 IqC9QxwzBIZr5d1hLacJw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 20:19:35 Chris Metcalf wrote:
> None of these changes fix any actual bugs, but are just various cleanups
> that fell out along the way.  In particular, some unused #defines and
> includes are removed, PREFETCH_STRIDE is added (the default is right for
> our shipping chips, but wrong for our next generation), our tile-specific
> prefetching code is removed so the (identical) generic prefetching code
> can be used instead, a comment is fixed to be proper GPL and not just a
> "paste GPL here" token, a "//" comment is converted to "/* */", etc.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
