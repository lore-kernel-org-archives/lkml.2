Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0FBRae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab0FBRac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:30:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
In-Reply-To: Oleg Nesterov's message of  Wednesday, 2 June 2010 17:42:10 +0200 <20100602154210.GA9622@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com>
	<20100601201843.GA20732@redhat.com>
	<20100602221805.F524.A69D9226@jp.fujitsu.com>
	<20100602154210.GA9622@redhat.com>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Message-Id: <20100602172956.5A3E34A491@magilla.sf.frob.com>
Date: Wed,  2 Jun 2010 10:29:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not just test TIF_MEMDIE?

Thanks,
Roland
