Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2AKG5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:57:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61656 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2AKG5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:57:43 -0500
MIME-Version: 1.0
In-Reply-To: <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	<CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
	<1326223998.14089.26.camel@haakon2.linux-iscsi.org>
Date: Wed, 11 Jan 2012 07:57:41 +0100
X-Google-Sender-Auth: yKPPK-FPbRc3cS9yBlkr5l8Zdt0
Message-ID: <CAO+b5-oqsimTj6fRa=euEegH8Sqg=N_j4vXs6u=j31Za+WBKOw@mail.gmail.com>
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

2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> These are all very minor and did not warrant another full RFC posting.

There is a reason why the ib_srpt patch should have been reposted:
Last WQE handling is still wrong, despite a patch being available
(http://www.spinics.net/lists/linux-rdma/msg09982.html).

Bart.
