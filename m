Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0KOXnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:43:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24726 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0KOXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:43:20 -0500
Date: Tue, 16 Nov 2010 00:31:00 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, David Rientjes wrote:

[...]
> If you would like to cite these "multiple" applications that need to be 
> converted to use oom_score_adj (I know of udev), please let me know and 
> if they're open-source applications then I will commit to submitting 
> patches for them myself.  I believe the two year window is sufficient for 
> everyone else, though.
[...]

I'm not going into the debate about whether or not deprecating one tunable 
for two years is sufficient or not. I'm simply going to mention one app 
that I know of that needs to be converted to use "oom_score_adj" on my 
box :

[jj@dragon ~]$ uname -a
Linux dragon 2.6.37-rc1-ARCH-00542-g0143832-dirty #1 SMP PREEMPT Mon Nov 15 22:01:52 CET 2010 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz GenuineIntel GNU/Linux
[jj@dragon ~]$ dmesg | grep oom_adj
start_kdeinit (1502): /proc/1502/oom_adj is deprecated, please use /proc/1502/oom_score_adj instead.
[jj@dragon ~]$ /usr/lib/kde4/libexec/start_kdeinit --version

Qt: 4.7.1
KDE: 4.5.3 (KDE 4.5.3)



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

