Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0DITzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab0DITzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:55:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] proc_sched_show_task: use get_nr_threads()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 23 March 2010 16:09:38 +0100 <20100323150938.GA11056@redhat.com>
References: <20100323144839.GA10424@redhat.com>
	<20100323150938.GA11056@redhat.com>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20100409195428.1FBDDBD0E@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:54:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
