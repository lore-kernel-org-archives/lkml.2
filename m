Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1C3HrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:47:05 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:54481 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1C3HrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:47:03 -0400
X-ASG-Debug-ID: 1301471221-03d6a5652c1e780001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D92DFF4.9030801@fusionio.com>
Date: Wed, 30 Mar 2011 09:47:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
CC: linux-nilfs <linux-nilfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
References: <20110330.132555.158630340.ryusuke@osrg.net>
X-ASG-Orig-Subj: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
In-Reply-To: <20110330.132555.158630340.ryusuke@osrg.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301471221
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59385
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 06:25, Ryusuke Konishi wrote:
> I've found a regression of nilfs2 file system in 2.6.39-rc1.
> 
> The recent per-queue plugging removal patch causes kernel oopses in
> nilfs.  The following patch will fix this.
> 
> I'll send it to Linus along with other bug-fixes.

Irk, I guess we need the empty aops then.

You can add my acked-by to the patch, sorry about that.

-- 
Jens Axboe

