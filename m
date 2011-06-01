Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab1FAU5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:57:51 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55000 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326Ab1FAU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:57:50 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] ide: Fix bug caused by git merge
References: <1306956328.10135.36.camel@gandalf.stny.rr.com>
	<BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
X-Yow: Now, my ENTIRE LIFE is flashing before my EYES as I park my DODGE
 DART in your EXXON service area for a COMPLETE LUBRICATION!!
Date: Wed, 01 Jun 2011 22:57:45 +0200
In-Reply-To: <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com> (Linus
	Torvalds's message of "Thu, 2 Jun 2011 05:27:45 +0900")
Message-ID: <m2oc2htgl2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Git has wonderful support for helping resolve merges intelligently,
> but you need to know how to do it. See the gitk example above - run it
> and ponder.

Btw, when I redo the merge and let kdiff3 resolve the conflicts (via git
mergetool) it does exactly the right thing. :-)

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
