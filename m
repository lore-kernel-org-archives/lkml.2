Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0JZNTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857Ab0JZNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:19:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 3/4] move cred_guard_mutex from task_struct to signal_struct
In-Reply-To: KOSAKI Motohiro's message of  Tuesday, 26 October 2010 22:04:50 +0900 <20101026220314.B7DD.A69D9226@jp.fujitsu.com>
References: <20101025174220.GA21375@redhat.com>
	<20101025175113.963CCC9E3C@blackie.sf.frob.com>
	<20101026220314.B7DD.A69D9226@jp.fujitsu.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20101026131826.5B262C9E36@blackie.sf.frob.com>
Date: Tue, 26 Oct 2010 09:18:26 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because [4/4] depend on [3/4] and I hope to backport it. Do you dislike it
> too?

Ah, OK.  That is indeed a fix for an important bug.  Not knowing the mm
code very well, I'm not in a position to judge whether it's safe enough
for a -stable stream or not.  If it is and it could be done safely
without relying on 3/4, that would seem safer to me, but it is not a
strong opinion.


Thanks,
Roland
