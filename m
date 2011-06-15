Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1FOHQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:16:01 -0400
Received: from dspnet.fr ([188.165.44.67]:54281 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1FOHQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:16:00 -0400
Date: Wed, 15 Jun 2011 09:15:56 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc3
Message-ID: <20110615071555.GA26721@dspnet.fr>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
 <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
 <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 10:59:41AM -0700, Linus Torvalds wrote:
> On Tue, Jun 14, 2011 at 5:15 AM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
> >
> > I've got a patch for my project to fix parsing of kernel version which
> > has only two numbers. Basically,
> >
> > - scanf(ver, "%u.%u.%u", &a, &b, &c)
> > + sscanf(ver, "%u.%u", &a, &b)
> 
> Please just fix it.
> 
> The projects that care about kernel version are buggy in so many ways
> that it's not funny.

His problem is recognizing "kernel version" vs. "filename" as a
parameter.
  depmod [ -e ]  [ -FSystem.map ]  [ -n ]  [ -v ]  [ version ]  [ filename... ]

Oh course, that's a stupid interface, but probably a hard one to
change.

  OG.

