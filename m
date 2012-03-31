Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2CaS5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:57:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41222 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2CaS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:57:40 -0400
Date: Sat, 31 Mar 2012 19:57:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs part 2
Message-ID: <20120331185738.GW6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk>
 <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
 <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:31:58AM -0700, Linus Torvalds wrote:
> On Sat, Mar 31, 2012 at 11:28 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It may be some other change than your pull... I will explore more, but
> > I thought I'd let you know that it's the prime suspect right now.
> 
> Verified. My tree just before the pull works fine (current tip plus a
> couple of my pending selinux avc optimizations). So it's your pull.

Works here...  OK, that makes selinuxfs one the most likely suspect; let
me check if I can reproduce any crap with that...  Do you see anything
selinux-related in the call chain, BTW?
