Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0EFGlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:41:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35498 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0EFGlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:41:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE26472.6040805@s5r6.in-berlin.de>
Date: Thu, 06 May 2010 08:40:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: indiscriminate get_maintainer.pl usage
References: <1273111054-10141-1-git-send-email-xiaosuo@gmail.com> 	<4BE25AE8.1060607@s5r6.in-berlin.de> <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>
In-Reply-To: <s2t412e6f7f1005052319sdbf3fdfbg256d11b983c4f304@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I should add --nogit option.

The script does get some useful information out of git (but obviously
also some questionable).

--roles and --rolestats give away some more data...

$ scripts/get_maintainer.pl --rolestats -f fs/eventpoll.c
Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/6=33%)
"Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/6=33%)
Davide Libenzi <davidel@xmailserver.org> (commit_signer:2/6=33%)
Roland Dreier <rolandd@cisco.com> (commit_signer:1/6=17%)
Stefan Richter <stefanr@s5r6.in-berlin.de> (commit_signer:1/6=17%)
linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
linux-kernel@vger.kernel.org (open list)

...but still don't distinguish between signed-off-by or reviewed-by on
one hand, and reported-by and tested-by on the other hand.  Cc'ing a
reporter or tester would only make sense if the patch changes something
that directly affects the reporter's/ tester's setup, e.g. reworks a
provisional fix.
-- 
Stefan Richter
-=====-==-=- -=-= --==-
http://arcgraph.de/sr/
