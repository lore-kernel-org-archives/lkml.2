Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1C2XkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:40:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab1C2XkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:40:18 -0400
Date: Tue, 29 Mar 2011 16:39:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8.5 3/3] cgroups: make procs file writable
Message-Id: <20110329163917.6b5d4149.akpm@linux-foundation.org>
In-Reply-To: <BANLkTikMgd5HvMyC1BTGzAtj_=Jk=wZm+A@mail.gmail.com>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
	<20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
	<AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
	<20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
	<AANLkTikkmfwk0nV0p=omz2ddrw+ZqWF1Lx3EfO6dTjEQ@mail.gmail.com>
	<20110315211353.GA9992@ghc17.ghc.andrew.cmu.edu>
	<AANLkTim4z_x_UQE__f5t73Dimja8PTTXTKKgj2phv6FY@mail.gmail.com>
	<20110322051841.GA12055@ghc17.ghc.andrew.cmu.edu>
	<BANLkTikMgd5HvMyC1BTGzAtj_=Jk=wZm+A@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 16:27:19 -0700
Paul Menage <menage@google.com> wrote:

> On Mon, Mar 21, 2011 at 10:18 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> > Makes procs file writable to move all threads by tgid at once
> >
> > From: Ben Blum <bblum@andrew.cmu.edu>
> >
> > This patch adds functionality that enables users to move all threads in a
> > threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> > file. This current implementation makes use of a per-threadgroup rwsem that's
> > taken for reading in the fork() path to prevent newly forking threads within
> > the threadgroup from "escaping" while the move is in progress.
> >
> > Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> OK, I guess this is ready to go in :-)

It all needs a refresh, retest and resend please.
