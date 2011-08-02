Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1HBTDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:03:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60621 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755006Ab1HBTDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:03:30 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18o2TUI33kobRsqErGU4jdj2T/EHOF8SgVe+2GGzv
	GnvcSpHx9Fwxtz
From: Sven Joachim <svenjoac@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
References: <20110801215908.GA11448@tassilo.jf.intel.com>
	<87sjpk9ttf.fsf@turtle.gmx.de>
	<20110802181751.GB7087@tassilo.jf.intel.com>
	<87aabraca3.fsf@turtle.gmx.de> <20110802185501.GC32027@1wt.eu>
Date: Tue, 02 Aug 2011 21:03:28 +0200
In-Reply-To: <20110802185501.GC32027@1wt.eu> (Willy Tarreau's message of "Tue,
	2 Aug 2011 20:55:01 +0200")
Message-ID: <8739hjab5r.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-02 20:55 +0200, Willy Tarreau wrote:

> On Tue, Aug 02, 2011 at 08:39:16PM +0200, Sven Joachim wrote:
>> I don't think that's the problem, since the v2.6.35.14 tag and the
>> commits that lead to it have been at
>> git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git for
>> at least twelve hours.  The problem is that while the tag is there, the
>> master branch is still at v2.6.35.13-original.  This happens if you just
>> "git push v2.6.35.14" without _also_ explicitly pushing the master
>> branch.  In that case, the commits leading to v2.6.35.14 get pushed (and
>> can be fetched with "git fetch -t") but are not on any branch.
>> 
>> Linus himself had already made this mistake at least twice, so it can
>> happen to anyone, I guess. :-)
>
> I too made this mistake a few times. However I just checked Andi's tree
> on hera and it's OK, master == v2.6.35.14, so possibly this is just a
> synchronization issue. Let's wait a bit.

Yes, it seems so.  In gitweb I now see the master branch at v2.6.35.14
as well, while it was at v2.6.35.13-original half an hour ago.

Cheers,
       Sven
