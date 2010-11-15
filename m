Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0KOCSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:18:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757078Ab0KOCSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:18:51 -0500
Date: Sun, 14 Nov 2010 18:19:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-Id: <20101114181905.bc5b44f9.akpm@linux-foundation.org>
In-Reply-To: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
	<AANLkTikSq-qC28uurd17RGup92Kao7enCiGJkDnJG+94@mail.gmail.com>
	<20101115093410.BEFD.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 09:54:14 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 2010/11/13 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> > >
> > > Please apply this. this patch revert commits of oom changes since v2.6.35.
> > 
> > I'm not getting involved in this whole flame-war. You need to convince
> > Andrew, who has been the person everything went through.
> 
> I wonder why he deep silence.

Nothing to say, really.  Seems each time we're told about a bug or a
regression, David either fixes the bug or points out why it wasn't a
bug or why it wasn't a regression or how it was a deliberate behaviour
change for the better.

I just haven't seen any solid reason to be concerned about the state of
the current oom-killer, sorry.

I'm concerned that you're concerned!  A lot.  When someone such as
yourself is unhappy with part of MM then I sit up and pay attention. 
But after all this time I simply don't understand the technical issues
which you're seeing here.
