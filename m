Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0KYUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:01:26 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:37123 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab0KYUB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:01:26 -0500
X-ASG-Debug-ID: 1290715284-0853090e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CEEC091.7090501@fusionio.com>
Date: Thu, 25 Nov 2010 21:01:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Regression fixes for DRBD
References: <201011251735.02696.philipp.reisner@linbit.com>
X-ASG-Orig-Subj: Re: [GIT PULL] Regression fixes for DRBD
In-Reply-To: <201011251735.02696.philipp.reisner@linbit.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1290715284
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.47663
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-25 17:35, Philipp Reisner wrote:
> Hi Jens,
> 
> Please pull these two fixes for regressions.
> 
> One significant performance regression (more than factor 10 for a 
> special workload), and a locking regression.
> 
> Those two should go in before 2.6.37, I based it on your for-linus
> branch.

Looks good, pulled them in. I just asked Linus to pull, so these will
get in at the next pull request for this series.

-- 
Jens Axboe

