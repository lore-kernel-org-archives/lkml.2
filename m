Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0I2MTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab0I2MTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
Date: Wed, 29 Sep 2010 14:19:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>,
        linux-kernel@vger.kernel.org
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org> <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com> <20100928174459.53c5a865.akpm@linux-foundation.org>
In-Reply-To: <20100928174459.53c5a865.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009291419.39832.arnd@arndb.de>
X-Provags-ID: V02:K0:k+AUMaqj/U9rLE5LxreuIDhrHbn64SG/nnIMBYt4Cyz
 px9EY2ZQ3Q9pleoM+onga9aS8nq+5lQVqiGQ5wDOgz5h7xGW1/
 D+NPVuSQFumybnRLcOwAsLaW1uRDFNWQ+xFEn5zPjPykPQJgCk
 022P6GuxAJVHn2DxJFVPQxntCcMhVWyAnjHbNcCHo9w1RPPcr8
 PVJ+8ouK+lvXpUOSsCXtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010, Andrew Morton wrote:
> On Wed, 29 Sep 2010 02:27:55 +0200 "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com> wrote:
> > Was there any contest for function, which will cause many warnings?
> > 
> > I'm getting an awful lot of
> >   CC      kernel/trace/trace_sched_switch.o
> > In file included from kernel/trace/trace_sched_switch.c:8:
> > include/linux/fs.h:1278: warning: function declaration isn___t a prototype
> > include/linux/fs.h:1282: warning: function declaration isn___t a prototype
> >   CC      kernel/trace/trace_functions.o
> > In file included from include/linux/debugfs.h:18,
> >                  from kernel/trace/trace_functions.c:13:
> > include/linux/fs.h:1278: warning: function declaration isn___t a prototype
> > include/linux/fs.h:1282: warning: function declaration isn___t a prototype
> 
> Arnd has been bad.

Sorry about that, I obviously forgot to test without CONFIG_FILE_LOCKING.
Are you actually using that configuration, or did you find it during
random build testing?

> commit 0a4de5980db88de75b798b291524ba9af8553e7c
> Author:     Arnd Bergmann <arnd@arndb.de>
> AuthorDate: Sat Sep 18 15:09:31 2010 +0200
> Commit:     Arnd Bergmann <arnd@arndb.de>
> CommitDate: Sat Sep 25 18:07:47 2010 +0200
> 
>     fs/locks.c: prepare for BKL removal

I updated that commit now.

	Arnd
