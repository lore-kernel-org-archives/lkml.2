Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab0ENS4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:56:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758413Ab0ENSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:55:59 -0400
Date: Fri, 14 May 2010 11:53:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification updates for 2.6.34-rcX
In-Reply-To: <1273854980.2826.28.camel@localhost>
Message-ID: <alpine.LFD.2.00.1005141152090.3711@i5.linux-foundation.org>
References: <1273854980.2826.28.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Eric Paris wrote:
> 
> Russell King (1):
>       Inotify: undefined reference to `anon_inode_getfd'

This one was bogus - it was already done in mainline _and_ in the tree you 
were applying the patch on.

I did a manual merge to edit out the duplicate Kconfig line.

		Linus
