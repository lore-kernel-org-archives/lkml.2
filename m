Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2DPTdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:33:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39674 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752101Ab2DPTdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:33:37 -0400
Message-ID: <1334604769.2726.0.camel@joe2Laptop>
Subject: [PATCH] checkpatch: revert --strict test for net/ and drivers/net
 block comment style
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Mon, 16 Apr 2012 13:32:49 -0600
In-Reply-To: <4F8C76A0.2050601@xenotime.net>
References: <20120416091719.GA4113@gmail.com>
	 <4F8C76A0.2050601@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
On Mon, 2012-04-16 at 12:44 -0700, Randy Dunlap wrote:
> On 04/16/2012 02:17 AM, Ingo Molnar wrote:
> >   aad4f6149831 checkpatch: add --strict tests for braces, comments and casts
> > made the default checkpatch run complain about the following 
> > perfectly fine multi-line comment block:

No, it didn't.

It only made checkpatch complain if --strict was
added to the command line arguments.

I don't care about the comment style, it is/was
David Miller's preferred style for drivers/net and
net/

I think a straight revert isn't appropriate.

Here's one that just removes the comment check.




