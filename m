Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0JYR1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:27:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab0JYR1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:27:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [resend][PATCH 3/4] move cred_guard_mutex from task_struct to signal_struct
In-Reply-To: KOSAKI Motohiro's message of  Monday, 25 October 2010 12:28:40 +0900 <20101025122801.9170.A69D9226@jp.fujitsu.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com>
	<20101025122801.9170.A69D9226@jp.fujitsu.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20101025172657.A9EC9C9E3C@blackie.sf.frob.com>
Date: Mon, 25 Oct 2010 13:26:57 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has my ACK if Oleg doesn't see any problems.

Thanks,
Roland
