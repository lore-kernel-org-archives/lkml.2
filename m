Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0K1WT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:19:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27533 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0K1WT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:19:27 -0500
Date: Sun, 28 Nov 2010 23:12:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Jiri Kosina <jkosina@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: =?ISO-8859-7?Q?Re=3A_=5BPATCH=5D=5Btrivial=5D_Kill_off_a_bunch_of_annoying__warning=3A_=A1inline=A2_is_not_at_beginning_of_declaration?=
In-Reply-To: <alpine.LNX.2.00.1011282303250.981@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1011282310160.29621@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011282128210.29621@swampdragon.chaosbits.net> <alpine.LNX.2.00.1011282303250.981@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010, Jiri Kosina wrote:

> On Sun, 28 Nov 2010, Jesper Juhl wrote:
> 
> > Hi,
> > 
> > These warnings are spewed during a build of a 'allnoconfig' kernel 
> > (especially the ones from u64_stats_sync.h show up a lot) when building 
> > with -Wextra (which I often do)..
> > They are
> >   a) annoying
> >   b) easy to get rid of.
> > This patch kills them off.
> 
> Hmm, this made me look into what -Wextra actually does ... and it seems 
> quite fishy for kernel. For example my gcc manpage tells me
> 
>        -Wempty-body
>            Warn if an empty body occurs in an if, else or do while statement.
> 	   This warning is also enabled by -Wextra.
> 
> And we do have quite a bunch of 'do { } while (0);' in kernel. So it seems 
> to me like you'll be getting much more noise with -Wextra than the lines 
> below, won't you?
> 

Yes, I'm getting a lot of noise, and most of it I'll just live with since 
it's not relevant.
But, some of it - like what this patch addresses - is noise that can 
easily just go away and I think it should.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

