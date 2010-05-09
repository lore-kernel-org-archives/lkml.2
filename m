Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab0EIGvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 02:51:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35992 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0EIGvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 02:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=fnyXThxXsWy37KvSfcff8+inAbK7yBGOP3uI+g5JmhPXJP9j1Z3uf6FbCF9vYefich
         EYLdKQKqvgOToBXynaLnvdhqGQy280WR1WC+y9LOW0p2AlcgsP2AeIuAb0Rw7jY/3BSv
         CYPlORgKFuV0qulx7LzmrU3Yc4HqIyuSkvFsE=
MIME-Version: 1.0
In-Reply-To: <y2gf22d86811005071051q28a4fa84g2a3ea1a7ff487934@mail.gmail.com>
References: <y2gf22d86811005071051q28a4fa84g2a3ea1a7ff487934@mail.gmail.com>
Date: Sun, 9 May 2010 12:21:35 +0530
Message-ID: <j2if22d86811005082351x975e868foe1b40bf7a89e1448@mail.gmail.com>
Subject: Re: Link time manipulation of kernel symbols like read/write
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple more questions:

1. How does the dynamic linking/loading happen in kernel? What is the
equivalent of ld-linux.so in kernel space?

Any pointer will be helpful

-Leo

On Fri, May 7, 2010 at 11:21 PM, Leonidas . <leonidas137@gmail.com> wrote:
> Hi folks,
>
> Is it possible to wrap module entry points like open/close during the
> module compilation?
> By wrapping, I mean interposing using linker --wrap option. This is
> very much possible in
> user space and is commonly used to interpose library functions.
>
> E.g.
>
> void *
> __wrap_malloc (int c)
> {
>  printf ("malloc called with %ld\n", c);
>  return __real_malloc (c);
> }
>
> int main()
> {
>    malloc(17);
>    return 0;
> }
>
> Above works expected, can we wrap kmalloc this way?
>
> -Leo.
>



-- 


-Leo.
