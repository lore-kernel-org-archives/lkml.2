Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0E2OSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:18:13 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:53315 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0E2OSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=nfeF+su16cFq4ZKOvM2kQEcc7nUindTNpmElyJn8e2FjNsLxg4EFuZ5Bhu2ir2I8Or
         T66C2qV9ILlb/n8iaMZnPzHA6RTq13eWgLLn3zbjwDpeYDie80gk/JYQN6/TO0Yqo371
         A9v03xFI8Ovttyn9RJg6nJ0tCJntFJSv6Mohg=
MIME-Version: 1.0
In-Reply-To: <20100529134625.GC25092@liondog.tnic>
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com> 
	<20100529121019.GA25092@liondog.tnic> <AANLkTimtX4HSql73IEAwOBqC2-R25713IgfihGR-fQm9@mail.gmail.com> 
	<20100529134625.GC25092@liondog.tnic>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 29 May 2010 22:17:50 +0800
Message-ID: <AANLkTik7jSq4Gh5sWd8vEA5tF7yqxaA7EGZQ_Qp5byk4@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
To: Borislav Petkov <bp@alien8.de>, Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 9:46 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Changli Gao <xiaosuo@gmail.com>
> Date: Sat, May 29, 2010 at 09:26:47PM +0800
>
>> Did the compiler warning appear after applying my patch? It doesn't
>> happen when I testing it.
>
> yep, using gcc (Debian 4.4.4-2) 4.4.4 here.
>
>> And I don't pass bio to do_mpage_readpage(), but I pass NULL instead.
>
> True, but you still need that bio pointer so you might just as well set
> it to NULL as the original code does.
>

I'm using gcc 4.4.3(Gentoo). It's strange. on that line, bio is only
used as left value. Maybe it is a compiler bug, or you didn't apply my
patch properly.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
