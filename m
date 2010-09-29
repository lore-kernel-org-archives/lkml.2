Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0I2Ao3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:44:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab0I2Ao2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:44:28 -0400
Date: Tue, 28 Sep 2010 17:44:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Message-Id: <20100928174459.53c5a865.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 02:27:55 +0200 "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:

> Hi,
> 
> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> 
> I wonder why are these two functions in include/linux/fs.h
> static inline void lock_flocks()
> {
> }
> 
> static inline void unlock_flocks()
> {
> }
> 
> Was there any contest for function, which will cause many warnings?
> 
> I'm getting an awful lot of
>   CC      kernel/trace/trace_sched_switch.o
> In file included from kernel/trace/trace_sched_switch.c:8:
> include/linux/fs.h:1278: warning: function declaration isn___t a prototype
> include/linux/fs.h:1282: warning: function declaration isn___t a prototype
>   CC      kernel/trace/trace_functions.o
> In file included from include/linux/debugfs.h:18,
>                  from kernel/trace/trace_functions.c:13:
> include/linux/fs.h:1278: warning: function declaration isn___t a prototype
> include/linux/fs.h:1282: warning: function declaration isn___t a prototype

Arnd has been bad.

commit 0a4de5980db88de75b798b291524ba9af8553e7c
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Sat Sep 18 15:09:31 2010 +0200
Commit:     Arnd Bergmann <arnd@arndb.de>
CommitDate: Sat Sep 25 18:07:47 2010 +0200

    fs/locks.c: prepare for BKL removal

