Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2ANPUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:20:10 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39529 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab2ANPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:20:04 -0500
Message-ID: <1326554397.3293.13.camel@dabdike.airangel.com>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@kernel.org>, J?rn Engel <joern@purestorage.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Sat, 14 Jan 2012 15:19:57 +0000
In-Reply-To: <20120111104940.GA5394@infradead.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
	 <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
	 <1326225067.3264.51.camel@dabdike.int.hansenpartnership.com>
	 <20120111104940.GA5394@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 05:49 -0500, Christoph Hellwig wrote:
> On Tue, Jan 10, 2012 at 01:51:07PM -0600, James Bottomley wrote:
> > > The changes since the Nov 4 RFC are listed in the patch commit log:
> > > 
> > > ib_srpt: Make compilation with BUG=n proceed`
> > > ib_srpt: Use new target_core_fabric.h include
> > > ib_srpt: Check hex2bin() return code to silence build warning
> > > 
> > > These are all very minor and did not warrant another full RFC posting.
> > 
> > They might not warrant a full RFC reposting, but individually they
> > should have been posted to the list, so Bart is right.
> 
> At least 2 and 3 list, just not as global patches against the
> target tree, not ib_srpt specificly:
> 
> 2 is from: [PATCH] target: header reshuffle, part2
> 3 is from: [PATCH 5/5] target: check hex2bin result
> 
> Not sure about 1.
> 
> I'm really getting tired of this bickering. It's a brand new driver and
> doesn't have to be perfect.  While Bart generally has technically good
> points there's really no reason to put his remaining fixups in after
> the driver has been merged and available to a wieder audience.

Absolutely.  I was just reminding about git best practises, not NAKing a
pull.  Putting this in the kernel and sorting out the rough edges later
is fine by me ... just make sure the rough edges go over the list ...

James


