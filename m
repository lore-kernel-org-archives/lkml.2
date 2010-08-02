Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0HBVWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:22:31 -0400
Received: from xenotime.net ([72.52.115.56]:42593 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751076Ab0HBVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:22:29 -0400
Message-ID: <57767.148.87.67.132.1280784139.squirrel@www.xenotime.net>
In-Reply-To: <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
    <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
Date: Mon, 2 Aug 2010 14:22:19 -0700 (PDT)
Subject: Re: [PATCH] nconfig: add search support
From: rdunlap@xenotime.net
To: nir.tzachar@gmail.com
Cc: mmarek@suse.cz, rdunlap@xenotime.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, nir.tzachar@gmail.com, sam@ravnborg.org,
        trapdoor6@gmail.com, justinmattock@gmail.com
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, August 1, 2010 12:20 am, nir.tzachar@gmail.com wrote:
> From: Nir Tzachar <nir.tzachar@gmail.com>
>
>
> Remove the old hotkeys feature, and replace by a regular string search.
> From nconfig help:
>
>
> Pressing '/' triggers search mode. nconfig does regular string match,
> case insensitive, starting at the begining of each menu line. Pressing
> Enter highlights the next match, Backspace removes one character from
> the match string. Pressing either '/' again or ESC exits search mode.
>
> Rebind the '/' key (which allowed to search for symbols) to F8
>
>
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
> ---
> scripts/kconfig/nconf.c |  261
> ++++++++++++++++++++++-------------------------
> scripts/kconfig/nconf.h |    3 +- 2 files changed, 125 insertions(+), 139
> deletions(-)


A few other comments:

These help text lines should end with a period:

  Pressing SpaceBar toggles between the above options

  <Esc> always leaves the current window


The F-key help along the bottom line should be forced to fit
into 80 columns.  F9 (exit) especially should be visible.


This F3 should be F5:

  Press <Esc>, <F3> or <left-arrow> to go back one menu,


How about we make nconfig the default in linux-next
so that it will be used more?


