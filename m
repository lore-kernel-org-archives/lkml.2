Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1HWNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:09:58 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:40080 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab1HWNJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:09:49 -0400
X-ASG-Debug-ID: 1314104988-03d6a50f471b830001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E53A699.6050602@fusionio.com>
Date: Tue, 23 Aug 2011 15:09:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>, <joe.jin@oracle.com>
Subject: Re: [GIT PULL] (xen) stable/for-jens for your 3.1-rc2 bugfix branch
References: <20110822160259.GB24763@dumpdata.com>
X-ASG-Orig-Subj: Re: [GIT PULL] (xen) stable/for-jens for your 3.1-rc2 bugfix branch
In-Reply-To: <20110822160259.GB24763@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314104988
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72597
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-22 18:02, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens
> 
> I've two bug-fixes - on that just fixes indentation and comments and a
> more curious one: when instructing the backend to remove a mounted
> disk from a guest it would correctly refuse but also change the state
> as if it had removed it. Then when shutting down the guest, the guest
> would hang as the backend states was removed (ooops). The fix is in
> the backend to not remove (and move to the remove state) unless the
> frontend has really unmounted the disk.

Thanks, pulled.

-- 
Jens Axboe

