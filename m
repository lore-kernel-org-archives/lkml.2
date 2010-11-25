Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0KYQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:00:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:55131 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751226Ab0KYQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:00:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18m0V1R+74mtUuwxRWnm/0pSvxoIZFRIOIJHq0FUl
	7Z6HPN24Rest3n
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101121133744.GA10765@elte.hu>
References: <20101121133744.GA10765@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 09:00:29 -0700
Message-ID: <1290700829.4759.16.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 14:37 +0100, Ingo Molnar wrote:

> I tested it a bit, and autosched-v4 crashes on bootup with with attached config.

Hah.  Took a while between vacation activities and my wimpy little
memory ordering knowledge, but I've finally got it fingered out.  Tip's
update_shares() changes exposed previously invisible (to me) memory
ordering woes nicely it seems.

My vacation is (sniff) over, so I won't get a fully tested patch out the
door for review until I get back home.

	-Mike


