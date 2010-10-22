Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0JVQJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:09:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56664 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0JVQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YvT3oBEmme0cixaXTnXRZq79i9v7ahcNioU6NS9XpJM1nkNKZWZoPbuzND6N7Z5VuH
         pJwOdL/9F0zxoAJDXW687RwxOkIWWFh9J7w2UMaVTnRjblCtDxGce59TrgMbi8gNGd+R
         N5dT6Rpxcsit6SxmrPo/mxWoapsFX+GlqpS/k=
MIME-Version: 1.0
In-Reply-To: <E1P9Iy2-0001mY-UA@be1.7eggert.dyndns.org>
References: <fGqN4-2Ns-3@gated-at.bofh.it>
	<E1P9Iy2-0001mY-UA@be1.7eggert.dyndns.org>
Date: Fri, 22 Oct 2010 14:09:44 -0200
Message-ID: <AANLkTikebrSiW0unB8xy8UU1KNGaOZBu_HT=j9wQQeY5@mail.gmail.com>
Subject: Re: Mapping Inode to File
From: Artur Baruchi <mail.baruchi@gmail.com>
To: 7eggert@gmx.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, didnt understand your point.

Could you please clarify?

Note that I need to retrieve the file name in Kernel Space, Im able to
get the inode, but now I need to convert this inode to a name
(something that I could use).

Thanks in advance.

Att.
Artur Baruchi

On Fri, Oct 22, 2010 at 12:51 PM, Bodo Eggert <7eggert@web.de> wrote:
> Artur Baruchi <mail.baruchi@gmail.com> wrote:
>
>> Hi Guys.
>>
>> Is there a way to map an Inode number to a File (file path and name)
>> in a kernel module ?
>
> Imagine this:
>
> ln /foo/bar/baz /bar/baz/foo
> sleep 2147483647 < /foo/bar/baz &
> pivot_root /mnt /mnt/asd
> chroot /mnt/asd/foo
>
> What is the name you'd assign to that inode?
>
>
