Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939Ab1GMTSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:18:30 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57667 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1GMTS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:18:28 -0400
X-ASG-Debug-ID: 1310584700-01de280c1ec8780001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1DEF78.3020702@fusionio.com>
Date: Wed, 13 Jul 2011 21:18:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: reorder request_queue to remove 64 bit alignment
  padding
References: <1310393989.3058.5.camel@castor.rsk>
X-ASG-Orig-Subj: Re: [PATCH] block: reorder request_queue to remove 64 bit alignment
  padding
In-Reply-To: <1310393989.3058.5.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310584700
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 16:19, Richard Kennedy wrote:
> Reorder request_queue to remove 16 bytes of alignment padding in 64 bit
> builds.
> 
> On my config this shrinks the size of this structure from 1608 to 1592
> bytes and therefore needs one fewer cachelines.
> 
> Also trivially move the open bracket { to be on the same line as the
> structure name to make it easier to grep. 

Thanks, applied.

-- 
Jens Axboe

