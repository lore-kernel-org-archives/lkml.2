Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0FBT56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:57:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52018 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab0FBT54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eJBNKxnecHQq05qxAG9EG2v58rqx1g+i8m7tsnkiJZjXb/5CEjvPoPdNEf0Gy7RP8f
         RiLulZcU+o5OEGB/Mx+RRrJ2ONtfV7ixRHfB3u9Z1zPaLXzqz0kT6ts8OFoiqwwLhJVe
         2EjdntH6XewP+cg0QSNXs0kvMA2X5ZxXg1GBU=
MIME-Version: 1.0
In-Reply-To: <20100528155102.GK31073@ZenIV.linux.org.uk>
References: <20100528155102.GK31073@ZenIV.linux.org.uk>
Date: Wed, 2 Jun 2010 21:57:54 +0200
X-Google-Sender-Auth: luHZYICcyAmzgWfz5NTnPaPEYdU
Message-ID: <AANLkTinPY8R91dQ9hvQETgyUqUc_1rPs_aTUDquAj23z@mail.gmail.com>
Subject: Re: [git pull] vfs pile, part 2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 17:51, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Al Viro (5):
>      remove detritus left by "mm: make read_cache_page synchronous"

This introduced:

| fs/minix/dir.c: In function ‘dir_get_page’:
| fs/minix/dir.c:79: warning: label ‘fail’ defined but not used

As the whole fail block is now dead code.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
