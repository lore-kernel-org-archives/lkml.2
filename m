Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab0JFSHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:07:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602Ab0JFSHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bWl46IxdEw2oC+ti7J3SBwWQvNwLWAW9Mx/3Fnkfp2mvQyE3/iCgHp69E1+TMJGgVg
         e5qRjkYB/p5y6YSXFu+cRW54gVTe9mhNYR/egykMqHGNCatki2YAENWMNeYPHGPJPxas
         T/Q8/JIyOLVPpGERexYK7+xbY1DBBNKzIm4Is=
MIME-Version: 1.0
In-Reply-To: <20101006174831.02cf1691.sfr@canb.auug.org.au>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au>
	<AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com>
	<20101006174831.02cf1691.sfr@canb.auug.org.au>
Date: Wed, 6 Oct 2010 20:07:18 +0200
Message-ID: <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com>
Subject: Re: linux-next: Tree for October 6
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/6 Stephen Rothwell <sfr@canb.auug.org.au>:
> On Wed, 6 Oct 2010 08:25:24 +0200 Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:
>>
>> 2010/10/6 Stephen Rothwell <sfr@canb.auug.org.au>:
>> > Hi all,
>> >
>> > Changes since 20101005:
>>
>> It seems that you forgot to push to repo
>> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
>
> No, its just that the mirroring was slow/blocked :-(

Ok, I pulled latest tree. Thanks.

I already reported this before.

/home/test/linux-2.6/mm/slub.c: In function 'kmem_cache_init':
/home/test/linux-2.6/mm/slub.c:3031:2: error: 'slab_memory_callback'
undeclared (first use in this function)
/home/test/linux-2.6/mm/slub.c:3031:2: note: each undeclared
identifier is reported only once for each function it appears in
make[2]: *** [mm/slub.o] Error 1
make[1]: *** [mm] Error 2
make: *** [sub-make] Error 2

any thoughts?
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
