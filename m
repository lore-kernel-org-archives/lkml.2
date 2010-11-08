Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0KHVGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:06:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab0KHVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:06:23 -0500
Date: Mon, 8 Nov 2010 13:05:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: sage@newdream.net, yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the
 use of <module>-objs with <module>-y
Message-Id: <20101108130543.1188a63f.akpm@linux-foundation.org>
In-Reply-To: <EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
	<1289069918-2085-2-git-send-email-tdent48227@gmail.com>
	<EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 10:03:24 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> On Nov 6, 2010, at 2:58 PM, Tracey Dent wrote:
> 
> > Changed <module>-objs to <module>-y in Makefile.
> 
> Andrew Morton, hi.  I don't know whether Tracey Dent is expecting
> me to push this change to Linus, but lately you've been pushing the
> aoe changes.  I see similar changes in other
> drivers on the LKML, so if it looks good to you, would you mind please
> picking up this patch?

I queued both patches - I guess I'll send them to Jens.

I queued them as "unchangelogged patches".  Because what the changelogs told
us was utterly obvious from reading the patch.

What the changelogs didn't tell us was _why_ the change was made.  And
guess what?  I don't have a clue!  I just haven't been following these
kbuild minutea.

Tracey, please send a description of *why* this change is being made
and I'll add it to the changelogs.  Please include that explanation in
all such patches.

