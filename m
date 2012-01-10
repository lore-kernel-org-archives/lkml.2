Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2AJTdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:33:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53019 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2AJTdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:33:21 -0500
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@kernel.org>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
In-Reply-To: <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jan 2012 11:33:18 -0800
Message-ID: <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 19:19 +0000, Bart Van Assche wrote:
> 2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>
> > *) Initial merge for the SRP target (ib_srpt) fabric module (bart)
> 
> As far as I know the last time that patch was posted for review is
> November 4 (http://permalink.gmane.org/gmane.linux.scsi.target.devel/420).
> The date of the ib_srpt commit is December 16
> (http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=a42d985bd5b234da8b61347a78dc3057bf7bb94d).
> The two patches aren't identical. That makes me wonder whether that
> patch should have been reposted for review ?
> 

Hi Bart,

The changes since the Nov 4 RFC are listed in the patch commit log:

ib_srpt: Make compilation with BUG=n proceed`
ib_srpt: Use new target_core_fabric.h include
ib_srpt: Check hex2bin() return code to silence build warning

These are all very minor and did not warrant another full RFC posting.

--nab



