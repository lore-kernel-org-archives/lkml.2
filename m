Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2AQN6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:58:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48217 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2AQN6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904559397@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
	<5b429d6c4d0a3ad06ec01193eab7edc98a03e0de.1326803859.git.leonid.moiseichuk@nokia.com>
	<CAOJsxLFCbF8azY48_SHhYQ0oRDrf2-rEvGMKHBne2Znpj0XL4g@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB9826904559397@008-AM1MPN1-003.mgdnok.nokia.com>
Date: Tue, 17 Jan 2012 15:58:48 +0200
X-Google-Sender-Auth: cWSzFy8PmbKb7yD8zalx_LZrii8
Message-ID: <CAOJsxLEtuzEYVUtukrA1JeJnuOJ6OsOHOj=j2gs=-0NHYVPzLQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Memory notification pseudo-device module
From: Pekka Enberg <penberg@kernel.org>
To: leonid.moiseichuk@nokia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        riel@redhat.com, mel@csn.ul.ie, rientjes@google.com, dima@android.com,
        gregkh@suse.de, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 3:45 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 3. maybe someone needs similar solution, keep it internally = kill it. Now
> module looks pretty simple for me and maintainable. Plus one small issue
> fixed for swapinfo()

If you're serious about making this a generic thing, it must live in
mm/mem_notify.c. No ifs or buts about it.

I'm also not completely convinced we need to put memnotify policy in
the kernel. Why can't we extend Minchan's patch to report the relevant
numbers and let the userspace figure out when pressure is above some
interesting threshold?

                                Pekka
