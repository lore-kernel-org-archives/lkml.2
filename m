Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2DNVI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:08:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65147 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2DNVI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:08:58 -0400
MIME-Version: 1.0
In-Reply-To: <web-725985845@zbackend1.aha.ru>
References: <web-725985845@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 14:03:08 -0700
X-Google-Sender-Auth: Lf6lF8eBXaepaKOrRzwKH4DjL2A
Message-ID: <CA+55aFy2zh0BHvNYfUXvOaWWvagrKDrFy4DvTtPNjO7nS2G9Tw@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: werner <w.landgraf@ru.ru>
Cc: David Rientjes <rientjes@google.com>, Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:38 PM, werner <w.landgraf@ru.ru> wrote:
>
> I observed that then always kmemleak is almost at the beginning of top

Just disable CONFIG_DEBUG_KMEMLEAK.

You do realize that it's a pure debugging aid - akin to
CONFIG_DEBUG_PAGEALLOC - that is *not* meant to be run on production
systems. Exactly because it is very expensive. It basically scans all
the kernel areas for pointers and tries to find leaks.

                 Linus
