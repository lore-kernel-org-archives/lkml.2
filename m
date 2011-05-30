Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1E3UKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:10:55 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48351 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750783Ab1E3UKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:10:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=h1FF9WY8Ycnz3qK9zvicdyagke6J2iLW2YaX3a7RRKrrBEN5gwBpacjjIYSMOCEKFg08tGGQngbnrN2EA8evfgr4r/Bsg13dbBgndvYFVxaFG2JL5XCGjWC7eQOOmlGn;
Date: Mon, 30 May 2011 13:10:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Turning off the incremental diff robot
Message-Id: <20110530131052.8cc0c283.rdunlap@xenotime.net>
In-Reply-To: <20110530194500.GE10792@home.goodmis.org>
References: <4DE3E9E7.8020008@zytor.com>
	<20110530194500.GE10792@home.goodmis.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 15:45:00 -0400 Steven Rostedt wrote:

> On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> > Hi all,
> > 
> > With the v3.0 name change I was looking over what might break, and I'm
> > seriously considering turning off the incremental diff robot on
> > kernel.org.  It's not clear to me that it is actually useful anymore,
> > with git and all.
> 
> What is the incremental diff robot?
> 
> Does it make the patches between 2.6.x to 2.6.x+1?
> 
> > 
> > Do anyone actually use these anymore?
> 
> If the above is the case, yes I do. And we need to update the ketchup
> script as well.


and scripts/patch-kernel needs to be fixed (or dropped).

It will use the incremental diffs, but I doubt that patch-kernel or the
incremental diffs model has many users (he said with no proof :).

They could go away IMO.  I only use git or -rc or daily tarballs.
The only time that I have used incremental diffs was for a poor man's
bisect, but git does it much better.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
