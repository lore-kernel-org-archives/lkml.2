Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1LGBJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:09:36 -0500
Received: from ozlabs.org ([203.10.76.45]:35171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1LGBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:09:34 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH 21/25] kernel/module: replace DEBUGP with pr_debug
In-Reply-To: <1323198694-7186-22-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com> <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <1323198694-7186-22-git-send-email-jim.cromie@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Dec 2011 11:37:52 +1030
Message-ID: <87zkf5i3yv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Dec 2011 12:11:31 -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Use more flexible pr_debug.  This allows:
> 
>   echo "module module +p" > /dbg/dynamic_debug/control
> 
> to turn on debug messages when needed.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  kernel/module.c |   44 +++++++++++++++++++-------------------------
>  kernel/params.c |   14 ++++----------
>  2 files changed, 23 insertions(+), 35 deletions(-)

Split into 2 and applied.  This is a win, independent of the rest.

I reused the same commit message for the second patch,
with minor mods:

From: Jim Cromie <jim.cromie@gmail.com>
Subject: kernel/params: replace DEBUGP with pr_debug
Date: Tue, 6 Dec 2011 12:11:31 -0700

Use more flexible pr_debug.  This allows:

  echo "module params +p" > /dbg/dynamic_debug/control

to turn on debug messages when needed.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/params.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)
