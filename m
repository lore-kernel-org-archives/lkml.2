Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2ARP3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:29:35 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57282 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890Ab2ARP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F16D79C.2020402@redhat.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
	<4F16D79C.2020402@redhat.com>
Date: Wed, 18 Jan 2012 17:29:33 +0200
X-Google-Sender-Auth: bEy302ISw1EyhKqFxUXtLkei-Eo
Message-ID: <CAOJsxLHB=1t=kq2zASjAauFDrZQ5vROpjXs=XaSbmeMnzsaTLg@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: leonid.moiseichuk@nokia.com, minchan@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com, kosaki.motohiro@gmail.com,
        hannes@cmpxchg.org, mtosatti@redhat.com, akpm@linux-foundation.org,
        rhod@redhat.com, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 4:30 PM, Rik van Riel <riel@redhat.com> wrote:
> That seems like a horrible idea, because there is no guarantee that
> the kernel will continue to use NR_ACTIVE_ANON and NR_ACTIVE_FILE
> internally in the future.
>
> What is exported to userspace must be somewhat independent of the
> specifics of how the kernel implements things internally.

Exactly, that's what I'm also interested in.

                        Pekka
