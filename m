Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189Ab1ETSnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:43:10 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:36002 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab1ETSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:43:08 -0400
X-ASG-Debug-ID: 1305916987-03d6a50f36c3c10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD6B637.3060509@fusionio.com>
Date: Fri, 20 May 2011 20:43:03 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the s390 tree with Linus' tree
References: <20110519103539.aa1b5094.sfr@canb.auug.org.au>
X-ASG-Orig-Subj: Re: linux-next: manual merge of the s390 tree with Linus' tree
In-Reply-To: <20110519103539.aa1b5094.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305916987
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64308
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-19 02:35, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the s390 tree got a conflict in
> drivers/s390/char/tape_block.c between commit 9fd097b14918 ("block:
> unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers") from Linus'
> tree and commit 263fa17de50e ("[S390] Remove tape block device driver")
> from the s390 tree.
> 
> The latter just removes the file updated by the former.  So I did that.

That works, thanks. The other fixup you are carrying should be gone now,
I had to pull in 2.6.39 final to resolve other conflicts.

-- 
Jens Axboe

