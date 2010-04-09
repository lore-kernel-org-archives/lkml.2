Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0DITpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab0DITpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:45:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/2] keyctl_session_to_parent: use thread_group_empty()
	to check singlethreadness
In-Reply-To: Oleg Nesterov's message of  Tuesday, 23 March 2010 15:48:43 +0100 <20100323144843.GA10431@redhat.com>
References: <20100323144843.GA10431@redhat.com>
X-Windows: power tools for power losers.
Message-Id: <20100409194542.D8230BCFC@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 12:45:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
