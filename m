Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1CGTqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:46:51 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:44677 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab1CGTqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:46:50 -0500
X-ASG-Debug-ID: 1299527209-03d6a54f631cbc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D753625.6040300@fusionio.com>
Date: Mon, 7 Mar 2011 20:46:45 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "owen.smith@citrix.com" <owen.smith@citrix.com>
Subject: Re: [owen.smith@citrix.com: [Xen-devel] [PATCH 1/2 xen/stable-2.6.32.x]
  Union the blkif_request request specific fields]
References: <20110307173405.GA6087@dumpdata.com>
X-ASG-Orig-Subj: Re: [owen.smith@citrix.com: [Xen-devel] [PATCH 1/2 xen/stable-2.6.32.x]
  Union the blkif_request request specific fields]
In-Reply-To: <20110307173405.GA6087@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299527209
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.20
X-Barracuda-Spam-Status: No, SCORE=0.20 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=PR0N_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57339
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.20 PR0N_SUBJECT           Subject has letters around special characters (pr0n)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 18:34, Konrad Rzeszutek Wilk wrote:
> Jens,
> 
> Are you OK with this patch? I was thinking to push it for 2.6.39.
> I've it in my tree, but if you would rather carry it for the merge window
> it is in 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront-cleanup

I'd prefer block drivers going through the block tree, but if you have
it queued and since it's completely local to that driver, go ahead and
keep it in your tree. No worries on my side :-)

You can add my acked-by, if you want.

-- 
Jens Axboe

