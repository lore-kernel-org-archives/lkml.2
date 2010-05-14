Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab0ENTAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:00:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215Ab0ENTAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:00:05 -0400
Subject: Re: [GIT PULL] notification updates for 2.6.34-rcX
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1005141152090.3711@i5.linux-foundation.org>
References: <1273854980.2826.28.camel@localhost>
	 <alpine.LFD.2.00.1005141152090.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 14:59:27 -0400
Message-ID: <1273863567.2826.29.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 11:53 -0700, Linus Torvalds wrote:
> 
> On Fri, 14 May 2010, Eric Paris wrote:
> > 
> > Russell King (1):
> >       Inotify: undefined reference to `anon_inode_getfd'
> 
> This one was bogus - it was already done in mainline _and_ in the tree you 
> were applying the patch on.
> 
> I did a manual merge to edit out the duplicate Kconfig line.

I think I'm about 0/12 on pull requests......

/me crawls back into hiding.

