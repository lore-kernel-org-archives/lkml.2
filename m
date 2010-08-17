Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0HQNrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0HQNri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:47:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] [PATCH 2/4] dio: add page locking for direct I/O
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<alpine.DEB.2.00.1008110806070.673@router.home>
	<20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
	<20100812075941.GD6112@spritzera.linux.bs1.fc.nec.co.jp>
	<x49aaos3q2q.fsf@segfault.boston.devel.redhat.com>
	<20100816020737.GA19531@spritzera.linux.bs1.fc.nec.co.jp>
	<x49aaomheyi.fsf@segfault.boston.devel.redhat.com>
	<20100817081753.GA28762@spritzera.linux.bs1.fc.nec.co.jp>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 17 Aug 2010 09:46:56 -0400
In-Reply-To: <20100817081753.GA28762@spritzera.linux.bs1.fc.nec.co.jp> (Naoya
	Horiguchi's message of "Tue, 17 Aug 2010 17:17:53 +0900")
Message-ID: <x4939uduzan.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> BTW, from the discussion with Christoph I noticed my misunderstanding
> about the necessity of additional page locking. It would seem that
> without page locking there is no danger of racing between direct I/O and
> page migration. So I retract this additional locking patch-set.

OK, great!  ;-)

Cheers,
Jeff
