Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1GaTPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 15:15:14 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:45446 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab1GaTPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 15:15:08 -0400
X-ASG-Debug-ID: 1312139702-01de280c1e109200001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E35A9B1.9090309@fusionio.com>
Date: Sun, 31 Jul 2011 21:14:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Please pull NFS client changes
References: <1312082377.10882.1.camel@lade.trondhjem.org> <20110731182406.GA16470@infradead.org>
X-ASG-Orig-Subj: Re: Please pull NFS client changes
In-Reply-To: <20110731182406.GA16470@infradead.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312139702
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70525
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-31 20:24, Christoph Hellwig wrote:
> How does this manage to include the pnfs block code, which only was posted
> on the list a few hours before the pull request, and which doesn't
> appear to past testing very well (although the major issue seems to be
> core nfs code)?

And it doesn't even compile:

In file included from fs/nfs/client.c:51:0:
fs/nfs/pnfs.h:384:1: error: expected identifier or ‘(’ before ‘{’ token
fs/nfs/client.c: In function ‘nfs_server_set_fsinfo’:
fs/nfs/client.c:939:8: error: ‘struct nfs_server’ has no member named
‘pnfs_blksize’
fs/nfs/client.c: At top level:
fs/nfs/pnfs.h:382:20: warning: ‘set_pnfs_layoutdriver’ used but never
defined [enabled by default]
make[2]: *** [fs/nfs/client.o] Error 1


-- 
Jens Axboe

