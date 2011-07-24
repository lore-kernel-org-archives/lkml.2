Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1GXA2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 20:28:48 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51554 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1GXA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 20:28:41 -0400
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20110723163338.f8c08cf8.akpm@linux-foundation.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110723163338.f8c08cf8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Jul 2011 17:19:23 -0700
Message-Id: <1311466763.31450.364.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-23 at 16:33 -0700, Andrew Morton wrote:
> On Sat, 23 Jul 2011 16:16:15 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > So in the spirit of timely pull requests ahead of your upcoming summer
> > vacation, here is the long awaited and much debated initial merge commit
> > for v3.1-rc1 of drivers/target/iscsi to sync with latest bleeding edge
> > LIO v4.1 codebase.
> 
> None of this is in linux-next?  How did that happen?

I am happy to start using linux-next for target-pending.git mainline
items, but unfortuately these have yet to see direct linux-next testing
just yet..

Stephen, would you pretty please add target-pending.git/for-next into
linux-next build testing..?

Thanks,

--nab


