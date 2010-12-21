Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab0LUErY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:47:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45085 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab0LUErX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=kzHB+ozlt91SjREjps1PRzGaM7LaJYWE9QHX8SD6oYLHfk8gJQ1OY3muEBSZuOvDCZ
         YEz1GZlzlqEi6nujb9H6Wl5HAVzkz6Deayb9gt7PiIP4+NW6eCxcPUDIMgGSiWsT2XGj
         hGnnaImHLL40JIBfDlQqqYS17dNNn4KqYJsPA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101221120123.93838d16.sfr@canb.auug.org.au>
References: <20101221120123.93838d16.sfr@canb.auug.org.au>
Date: Tue, 21 Dec 2010 05:47:15 +0100
Message-ID: <AANLkTin_rx3EFVSTnUyK0uVshGxMm_yMVimEg60GSXLi@mail.gmail.com>
Subject: Re: linux-next: build failure in Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, stable@kernel.org,
        Thiago Farina <tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 2:01 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/block/cciss.c: In function 'cciss_revalidate':
> drivers/block/cciss.c:2839: error: expected ';' before 'if'
>
> Caused by commit 0fc13c8995cd96f4123de400c71c223d80400ed9 ("cciss: fix
> cciss_revalidate panic").  Was this even build tested?  More care
> required.
>
> I have reverted that commit for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

[ CC Thiago Farina ]

Did you see the patch "[PATCH] drivers/block/cciss.c: Fix compiling
error by adding ';' at the end of continue statement." from [1] from
Thiago?

- Sedat -

[1] http://lkml.org/lkml/2010/12/20/465
