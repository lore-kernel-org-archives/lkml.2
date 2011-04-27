Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab1D0Rgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:36:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab1D0Rgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <4DB7FBD8.20109@suse.cz>
References: <1303580576.4815.3.camel@localhost> <4DB7FBD8.20109@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Apr 2011 10:35:49 -0700
Message-ID: <BANLkTi=dbWOPcSqg5ueDzGJMoGDa9Bp3fA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Avoid buffer underrun in choice input
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:19 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> I applied this on 8th April, see
> http://www.spinics.net/lists/linux-kbuild/msg04431.html. Please check
> linux-next before reposting patches next time, now I either have to rewind
> the kconfig branch or let Linus merge it with a duplicate commit :-(.

Merging the occasional duplicate is normal flow, don't worry about it.
I'd much rather see the occasional smaller diffstat due to a diff that
got applied in both sides than I'd see people rebasing just to avoid
some silly duplicate.

It's if two branches consistently have many duplicates that I react,
because it tends to be some systematic error (often excessive
rebasing, but it could be some "ownership" argument too)

The "occasionally the same fix made it through two different trees" is
not just normal, it's _expected_ in distributed development. If it
never happens, that's a sign that people are serializing overmuch.

                                   Linus
