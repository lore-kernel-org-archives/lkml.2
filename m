Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab1COWCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:02:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49097 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1COWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:02:12 -0400
Date: Tue, 15 Mar 2011 23:02:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110315220210.GA8375@merkur.ravnborg.org>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315213248.GL22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al.

> Shortlog:
> Al Viro (45):
>       compat breakage in preadv() and pwritev()
>       fix race in audit_get_nd()
>       kill path_lookup()
....

It would be nice if you could start to prefix your
changelog message with the sub-system they touch.

In an attempt to try to use the language you understand...

Why the hell do you continue making it so freaking difficult
to see what sub-system your patchs touches.
All sane thinking persons has long since learned to prefix their
changelogs with for example "vfs: bla bla" so sane humans
has a chance to realize what they touches.
You could probarly do better than this :-)

	Sam
