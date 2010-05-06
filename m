Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0EFPmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:42:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49564 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab0EFPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:42:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 6 May 2010 08:42:51 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: indiscriminate get_maintainer.pl usage
In-Reply-To: <4BE26472.6040805@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.00.1005060826460.10407@makko.or.mcafeemobile.com>
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com>  <4BE25AE8.1060607@s5r6.in-berlin.de> <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com> <4BE26472.6040805@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Stefan Richter wrote:

> > I should add --nogit option.
> 
> The script does get some useful information out of git (but obviously
> also some questionable).
> 
> --roles and --rolestats give away some more data...
> 
> $ scripts/get_maintainer.pl --rolestats -f fs/eventpoll.c
> Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/6=33%)
> "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/6=33%)
> Davide Libenzi <davidel@xmailserver.org> (commit_signer:2/6=33%)
> Roland Dreier <rolandd@cisco.com> (commit_signer:1/6=17%)
> Stefan Richter <stefanr@s5r6.in-berlin.de> (commit_signer:1/6=17%)
> linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
> linux-kernel@vger.kernel.org (open list)
> 
> ...but still don't distinguish between signed-off-by or reviewed-by on
> one hand, and reported-by and tested-by on the other hand.  Cc'ing a
> reporter or tester would only make sense if the patch changes something
> that directly affects the reporter's/ tester's setup, e.g. reworks a
> provisional fix.

I have always maintained that code w/out the need of explicit entry in the 
MAINTAINERS file.  For isolated files people usually include the copyright 
owners and the ones listed in the comment header in general.
No problem in being explicitly listed if this causes noise during bug 
reporting.


- Davide


