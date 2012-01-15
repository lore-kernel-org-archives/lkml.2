Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2AOEES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 23:04:18 -0500
Received: from tundra.namei.org ([65.99.196.166]:57757 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2AOEEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 23:04:16 -0500
Date: Sun, 15 Jan 2012 15:04:12 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [GIT] Security updates for 3.3: SELinux
In-Reply-To: <CA+55aFwZxQkjmB6Gw7+MCY7DmyJtXjz+D6aGA7kA0X4q+qNd-g@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1201151501190.1556@tundra.namei.org>
References: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org> <CA+55aFwZxQkjmB6Gw7+MCY7DmyJtXjz+D6aGA7kA0X4q+qNd-g@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Linus Torvalds wrote:

> Now, if it's a trivial merge, it needs no explanation (although I also
> prefer that it not be done, so that I can see even those), but
> something like this where you actually need to resolve a semantic
> conflict that doesn't cause any real physical conflict at all I really
> prefer to be explained.

Sorry, yep, I should have explained it.

It was an odd situation in that it hadn't been in my tree at all thus far, 
so I wanted to do my own testing before requesting a pull to your tree.



- James
-- 
James Morris
<jmorris@namei.org>
