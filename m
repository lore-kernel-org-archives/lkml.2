Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1EPRjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:39:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1EPRjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bRmCSIWvuAYJYFORjzdLX4fENGl8aSEM5NNL3573YihTWocdvLYtK46F/zp1+4OO1f
         N/5RWNq4WYBmNuOLP1/8MdPj3ZqvazOMR+w7KpZS6AL50+Zr/HIQ8YXOrSUr3PDOXPCr
         llkKN6wNn6ZFgTKX+GXj9xyw+tneSnq3vBrLI=
MIME-Version: 1.0
In-Reply-To: <20110516125728.GB7941@redhat.com>
References: <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
 <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
 <20110513164435.GA22435@redhat.com> <BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com>
 <20110516125702.GA7941@redhat.com> <20110516125728.GB7941@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 16 May 2011 13:39:02 -0400
Message-ID: <BANLkTi=uXReN+PSjUxXLXwwh1b+GMV5dKw@mail.gmail.com>
Subject: Re: [PATCH v2] signal: trivial, fix the "timespec declared inside
 parameter list" warning
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 08:57, Oleg Nesterov wrote:
> Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
> needs the forward declaration of timespec.

looks good to me, thanks !
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
