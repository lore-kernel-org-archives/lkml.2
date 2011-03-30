Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1C3LoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:44:00 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:35253 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1C3Ln6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:43:58 -0400
X-ASG-Debug-ID: 1301485437-01de284cf8dafd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D93177B.50505@fusionio.com>
Date: Wed, 30 Mar 2011 13:43:55 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with 
 Linus' tree
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de> <20110328105348.GA27458@lst.de> <4D9069C1.4080602@fusionio.com> <20110329200813.GA9687@lst.de>
X-ASG-Orig-Subj: Re: [xfs-masters] linux-next: manual merge of the xfs tree with 
 Linus' tree
In-Reply-To: <20110329200813.GA9687@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301485437
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59400
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 22:08, Christoph Hellwig wrote:
> FYI, the blk_flush_plug call in ufs_truncate also seem to be almost
> certainly incorrect as it's followed by a yield.
> 
> That only leaves the RAID code as remaining modular users of it, and
> I suspect it really is something that shouldn't need to be exported.

Agree, once things have settled down we can reap the remaining and keep
it internal.

-- 
Jens Axboe

