Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab0FKUCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:02:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31222 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0FKUCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:02:34 -0400
Date: Fri, 11 Jun 2010 16:02:18 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Message-ID: <20100611200218.GE3018@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20100611193731.GA3018@think>
 <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
 <20100611194812.GD3018@think>
 <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C129650.00EF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:00:02PM -0700, Linus Torvalds wrote:
> On Fri, Jun 11, 2010 at 12:48 PM, Chris Mason <chris.mason@oracle.com> wrote:
> >
> > The others all fix oopsen or big problems, and I think fixing warnings
> > helps avoid false negatives as others look for real problems?
> >
> > I'm happy to rebase out the 3 non-criticals.
> 
> There seems to be more than three non-criticals. There's the warning
> fixes, the "unused variables" thing, the "memdup_user()" thing, a
> couple of unnecessary NULL checks removed etc. On the whole, I do not
> get the feeling that the pull request was actively trying to be
> minimal, and that's what I really want to see.

No problem, I like to err on the side of pulling in safe fixes from the
automated checkers so they don't have to go through results again.

But, I've got a completely minimal rebase now and I'm double checking
it.

-chris

