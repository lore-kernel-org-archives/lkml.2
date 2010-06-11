Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0FKTtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:49:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52595 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760530Ab0FKTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:49:14 -0400
Date: Fri, 11 Jun 2010 15:48:12 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Message-ID: <20100611194812.GD3018@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20100611193731.GA3018@think>
 <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C129314.0128:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:43:10PM -0700, Linus Torvalds wrote:
> On Fri, Jun 11, 2010 at 12:37 PM, Chris Mason <chris.mason@oracle.com> wrote:
> >
> > The master branch of the btrfs-unstable tree is a collection of fixes
> > and cleanups, including two btrfs regressions from rc1:
> 
> Ok, no pulling then. See all the millions of threads how I wanted only
> critical fixes for -rc3 since I'll be offline.
> 
> You have a couple of hours for a minimal fix pull request with just
> the regression fixes if you want to hit -rc3. Then I'll cut a release
> and be gone for a while.

I did limit this to actual fixes, the only pure cleanups are a commit
from Andi that drops unused code (fixing warnings from gcc), one to fix
a sparse warning in ioctl.c, and fixing a gcc warning in tree_search.

The others all fix oopsen or big problems, and I think fixing warnings
helps avoid false negatives as others look for real problems?

I'm happy to rebase out the 3 non-criticals.

-chris

