Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0HJKRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:17:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49466 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0HJKRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vpVfmhiUhTyYttx2D4d2fiy4tXg1mT9z91biMfrcfU/KNKmt9IfmDrUrs/MasBGepf
         dtGg+jSxtWAAbFnTbcNyW6PekOwZL3FVnpj7baulw7uKIVt186Z2814JpVW+FtHhejS1
         1Dok2f1GLR67hS7+lTXXSTJfZ0vnewPIsdlcg=
MIME-Version: 1.0
In-Reply-To: <20100810033536.GA31363@ZenIV.linux.org.uk>
References: <20100810033536.GA31363@ZenIV.linux.org.uk>
Date: Tue, 10 Aug 2010 06:17:05 -0400
Message-ID: <AANLkTimiVoe_5_Ls0-_25iFNXWsCtUyGz7k48HAEYNa+@mail.gmail.com>
Subject: Re: [git pull] vfs series, part 1
From: Nick Piggin <npiggin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 11:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Assorted work from the last cycle; among other things, there's
> a filesystem API change (->evict_inode() series), a lot of truncate
> rework stuff (mostly by Chris) and a bunch of fixes.
>
>        This is _not_ all; in particular, there's pending freeze/thaw
> locking rework and I would really like to see inode_lock splitup
> series separated and posted.  Along with vfsmount_lock and files_lock
> work.  Nick, could you do that ASAP, please?

My laptop is dead so it will have to wait until the end of the week
when I get home.
I'll do that as soon as possible.
