Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab0I0Tdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:33:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311Ab0I0Tdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:33:46 -0400
Date: Mon, 27 Sep 2010 12:32:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 1/2] autofs: Only declare function when CONFIG_COMPAT is
 defined
Message-Id: <20100927123252.8e1826e8.akpm@linux-foundation.org>
In-Reply-To: <201009251755.57690.arnd@arndb.de>
References: <1285334543-7074-1-git-send-regression-fweisbec@gmail.com>
	<201009251755.57690.arnd@arndb.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Sep 2010 17:55:57 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 24 September 2010 15:22:22 Frederic Weisbecker wrote:
> > From: M__rton N__meth <nm127@freemail.hu>
> > 
> > The patch solves the following warnings message when CONFIG_COMPAT
> > is not defined:
> > 
> > fs/autofs/root.c:30: warning: ___autofs_root_compat_ioctl___ declared ___static___ but never defined
> > 
> > Signed-off-by: M__rton N__meth <nm127@freemail.hu>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> My initial reaction was to put these into my bkl/vfs tree, but then I noticed
> that they are against a 2.6.36 bug. Who's taking care of getting them upstream?
> 
> - Ian (maintainer)
> - Arnd (who wrote the broken patch to start with)
> - Frederic (who pushed the broken patch to Linus)
> - Andrew (took them into -mm)
> 
> I don't care either way, just trying to make sure it gets there and we don't
> all submit the same patch simultaneously.

The usual deal: if it turns up in linux-next then I drop it.  If it
doesn't then I'll merge it into 2.6.37.

