Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0H3PKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:10:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0H3PKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t8JCxY6NngcTPNt7jIDP/CMFxGXuqwy6uQQKQn2SW6zCWQ5igNmHVjOF6QBuaFD8SS
         pMKBh2ZqQdU37Y457H6jzmuPPm+2Q931/iT1ZA007w+ps/h4TyxhV/4P8OTatXrzitDo
         DdoXzO5AO2TIGltTupTjeEQyflYxFgPXwkL5E=
Subject: Re: [Uclinux-dist-devel] [PATCH] mtd: Blackfin NFC: fix invalid
 free in remove()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <AANLkTikE93Uqnf7_8p72rEhcRydmx0LdBVCM_z3tNr-z@mail.gmail.com>
References: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
	 <1283173086.12995.74.camel@brekeke> <1283173173.12995.75.camel@brekeke>
	 <AANLkTikE93Uqnf7_8p72rEhcRydmx0LdBVCM_z3tNr-z@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 18:10:47 +0300
Message-ID: <1283181047.2005.1.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 09:32 -0400, Mike Frysinger wrote:
> On Mon, Aug 30, 2010 at 08:59, Artem Bityutskiy wrote:
> > On Mon, 2010-08-30 at 15:58 +0300, Artem Bityutskiy wrote:
> >> On Sat, 2010-08-28 at 16:42 -0400, Mike Frysinger wrote:
> >> > Since info->mtd isn't dynamically allocated, we shouldn't attempt to
> >> > kfree() it.  Otherwise we get random fun corruption when unloading
> >> > the driver built as a module.
> >> >
> >> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >> > ---
> >> > note: this should be merged for 2.6.36 and probably sent to stable trees
> >>
> >> You send the same patch 2 times once with this note and the other time
> >> without this note. Which one should be ignored?
> >
> > I guess it is 2.6.36 material. Also, if you want this in -stable, add
> > corresponding CC please.
> 
> once it gets merged, then i can notify the stable guys

AFAIK, this is not the way they prefer to work. The right protocol is
that you add 'Cc: stable@kernel.org' to the commit message, ane they
pick the patch. I might be mistaken, but AFAIK this is the way.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

