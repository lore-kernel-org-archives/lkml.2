Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030610Ab2CCARq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:17:46 -0500
Received: from mail.lang.hm ([64.81.33.126]:60345 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab2CCARq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:17:46 -0500
Date: Fri, 2 Mar 2012 16:17:32 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Ted Ts'o" <tytso@mit.edu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
In-Reply-To: <20120303000203.GH22215@thunk.org>
Message-ID: <alpine.DEB.2.02.1203021616040.23477@asgard.lang.hm>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <20120303000203.GH22215@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Ted Ts'o wrote:

> Stupid question.  Your patch requires unaligned accesses to not have a
> heavy penalty, right?  Wasn't it the case that some generations of x86
> had pretty large penalties for aligned accesses?  Is that something we
> need to worry about?

another stupid question

since the code that it's replaceing did byte-at-a-time access, wouldn't 
that be at least as bad as the new code?

or did some CPUs have efficient char access, but inefficient unaligned 
word access?

David Lang
