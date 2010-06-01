Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0FAVLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:11:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab0FAVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:11:06 -0400
Date: Tue, 1 Jun 2010 14:05:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
cc: David Howells <dhowells@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH] NOMMU: Add '[stack]' label to 
 /proc/pid/maps output
In-Reply-To: <AANLkTim_XTH-vhUx1em50GvfBSA4_UhlSJqtP46wh8F9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006011359590.8175@i5.linux-foundation.org>
References: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk>  <alpine.LFD.2.00.1006011204270.8175@i5.linux-foundation.org> <AANLkTim_XTH-vhUx1em50GvfBSA4_UhlSJqtP46wh8F9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Mike Frysinger wrote:
> 
> to be fair, this patch was written a few kernel revisions ago and
> you're referring to commit merged a few weeks ago ...

Yeah, but it got sent to me today, which is why I reacted. But:

> but i dont think we're talking the same thing.  that commit refers to
> [threadstack].  afaict, [stack] is still in there.

Oooh, and yes I did miss that entirely. The "[stack]" thing has been part 
of /proc/pid/maps since 2005 (v2.6.12-rc1 according to the historical 
logs), so it never even entered my mind that it would be about that 
ancient thing.

But right you are, and I withdraw any objections. Sorry for the noise,

			Linus
