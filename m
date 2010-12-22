Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0LVKWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:22:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38097 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0LVKWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=JEGMj+2PSfr5uPuJV/2tMc1oIgx0J8VWyEsq3bVnMkJR7dHUl3/yJwakrzvOLzHqY7
         lNRVIXyEysSfpI4ybGir5I8acXv0ueFfbgMNVBwsc28t2x0NAEjSFLcKpsQBiQfCyE8B
         U2q7QeN98Fys6X0Z4AhiPsC6uYydMvC8YUbRE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101222095332.GA3430@amd>
References: <20101222095332.GA3430@amd>
Date: Wed, 22 Dec 2010 11:22:05 +0100
Message-ID: <AANLkTimRnWmQgd25S2LjaWsGogCeiTWjK9HT25Uv9O38@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:53 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> Git tree is here:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>
> Branch is:
>
>    vfs-scale-working
>
> Changes since last posting:
> * Fix for the cgroupfs crash (probably temporary until Al's fixes are
>  merged).
> * Fix a couple of bisectability bugs.
> * Fix a race in disconnected dentry alias handling causing NFS to explode
>  under load. Basically the patch to split dentry hash locks needs to
>  lock the s_anon list with a seperate lock, which it wasn't doing
>  properly in the d_move() code.
>
> Thanks to all testers.
>

[ CC Al Viro and Lennart Poettering ]

Thanks for fixing this so quickly, Nick.
I am looking forward to see Al's vfs work got merged into linux-next.

Here some feedback from IRC #systemd/freenode (21-Dec-2010, UTC+1):

[17:14:23] <mezcaler1> dileks: fun that we are able to trigger such problems
[17:14:46] <mezcaler1> dileks: seems systemd is definitely a good
"test case" already ;-)


- Sedat -
