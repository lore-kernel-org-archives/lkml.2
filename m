Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1COWsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:48:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab1COWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110315221818.GN22723@ZenIV.linux.org.uk>
References: <20110315213248.GL22723@ZenIV.linux.org.uk> <20110315221818.GN22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Mar 2011 15:47:55 -0700
Message-ID: <AANLkTi=BgLcfw-XyJRw52eiUSf9=oF6oUQKEVTtWB51K@mail.gmail.com>
Subject: Re: [git pull] VFS - the first pile
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 3:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, a question about rebases: is that kind of situation worth doing
> a rebase of the queue/backmerge/etc.?

No. If it's the same patch I already applied, it will generally merge
cleanly, it's better to leave in the history than to rewrite things
just to avoid some trivial duplication.

                   Linus
