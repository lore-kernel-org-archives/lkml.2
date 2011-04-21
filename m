Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1DURb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:31:59 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:56918 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1DURb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:31:56 -0400
X-ASG-Debug-ID: 1303407115-03d6a55d38f7970001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DB06A06.7030208@fusionio.com>
Date: Thu, 21 Apr 2011 19:31:50 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Neil Brown <neilb@suse.de>, "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] block: don't propagate unlisted DISK_EVENTs to  userland
References: <20110421170826.GC15988@htj.dyndns.org> <BANLkTinwPt=aRSsh_Ppb8hLOaURh6mL2GQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] block: don't propagate unlisted DISK_EVENTs to  userland
In-Reply-To: <BANLkTinwPt=aRSsh_Ppb8hLOaURh6mL2GQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303407115
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61521
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 19:25, Linus Torvalds wrote:
> Should I take these as patches, or through Jens/David/Who?
> 
> I'll happily take them as patches, but I'd also like to hear
> confirmation from the people who saw the lock-up that it's gone now..

I'm pulling them in now, with the elevator patch referenced in the IO
scheduler switch email. I've verified that it fixes the ide-cd bug for
me.

-- 
Jens Axboe

