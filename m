Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2AJTTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:19:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab2AJTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:19:04 -0500
MIME-Version: 1.0
In-Reply-To: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
Date: Tue, 10 Jan 2012 19:19:01 +0000
X-Google-Sender-Auth: 2l_wnbunPA_VrEG5i_0FMbKIBxo
Message-ID: <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
From: Bart Van Assche <bvanassche@acm.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@kernel.org>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>
> *) Initial merge for the SRP target (ib_srpt) fabric module (bart)

As far as I know the last time that patch was posted for review is
November 4 (http://permalink.gmane.org/gmane.linux.scsi.target.devel/420).
The date of the ib_srpt commit is December 16
(http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=a42d985bd5b234da8b61347a78dc3057bf7bb94d).
The two patches aren't identical. That makes me wonder whether that
patch should have been reposted for review ?

Thanks,

Bart.
