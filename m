Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab1FAUmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:42:05 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:38422 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1FAUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:42:03 -0400
X-ASG-Debug-ID: 1306960920-01de280c1e16490001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE6A414.802@fusionio.com>
Date: Wed, 1 Jun 2011 22:41:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] ide: Fix bug caused by git merge
References: <1306956328.10135.36.camel@gandalf.stny.rr.com> <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] ide: Fix bug caused by git merge
In-Reply-To: <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306960920
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65326
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 22:27, Linus Torvalds wrote:
> Jens, you really can't do that. When you see a conflict marker, you
> need to look at WHY. The conflict may well be because of removed lines
> rather than added lines, the correct resolution is NOT necessarily to
> just take everything within the conflicting region.

Of course I look at the conflicts. I don't know what happened in this
case. Contrary to what you think, I do do regular merges. Usually not in
external branches, and if I do, it's only to resolve non-trivial
conflicts.

And I don't know why this one got so screwed up, well reversed really.

-- 
Jens Axboe

