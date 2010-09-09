Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0IITYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:24:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61344 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0IITYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gUVK/bHYMkgh48ec8L+xoAqIm8w6G8UspwI0PJ+hMsTUqXlhZfBTAUPvi62tg/Km+7
         QaXo9xoPX/tTv+qzHJ2QBZe+fIeYpyqX9NSwuKZGfZL1g59vlSewYKy604xKHoXwvcJQ
         QxkMsJn7ar2B/WXPQReQINOWMAJrKtE1EpGmw=
MIME-Version: 1.0
In-Reply-To: <1284060106.24986.215.camel@Joe-Laptop>
References: <1284056536.24986.182.camel@Joe-Laptop> <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
 <1284060106.24986.215.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 15:24:14 -0400
Message-ID: <AANLkTin+twU1y_C6jfNDXruuoVncEivRO=2=1Jg69Xe=@mail.gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warnings for static char that
 could be static const char
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 15:21, Joe Perches wrote:
> Add warnings for possible missing const uses of
>        static char foo[] = "bar"
>    that could be
>        static const char foo[] = "bar"
> and
>        static const char *foo[] = {"bar", "baz"}
>    that could be
>        static const char * const foo[] = {"bar", "baz"}

guess you missed my last e-mail about not bothering checking the
static or the contents :)

> +               if ($line =~ /\bconst\s+char\s*\*\s*(\w+)\s*\[\s*\]/) {
-mike
