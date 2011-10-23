Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1JWUTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 16:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1JWUTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 16:19:12 -0400
Date: Sun, 23 Oct 2011 21:19:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Leun <ml@newton.leun.net>
Cc: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] Bisected: Massive memory leak in dm-snapshot in 3.1
	development introduced
Message-ID: <20111023201900.GA13890@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Michael Leun <ml@newton.leun.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
References: <20111023112140.37fd8b3d@xenia.leun.net> <CA+55aFzfFpnEc+Eerdi9SfMw4o17ONfYCHksJkD1O6AS5U2DoQ@mail.gmail.com> <20111023134449.GA13703@agk-dp.fab.redhat.com> <20111023163042.4a93936c@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023163042.4a93936c@xenia.leun.net>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 04:30:42PM +0200, Michael Leun wrote:
> On Sun, 23 Oct 2011 14:44:49 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> > Michael - can you test if this solves the problem?

OK, let's go with this patch then.

Linus, you can pull it from here:

  http://people.redhat.com/agk/git/linux-dm for-linus

Alasdair G Kergon (1):
      dm kcopyd: fix job_pool leak

 drivers/md/dm-kcopyd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

