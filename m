Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0DHByw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173Ab0DHBys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:54:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ia64: ptrace_attach_sync_user_rbs: avoid "task->signal
	!= NULL" checks
In-Reply-To: Oleg Nesterov's message of  Thursday, 18 March 2010 19:53:07 +0100 <20100318185307.GA18352@redhat.com>
References: <20100318185307.GA18352@redhat.com>
X-Shopping-List: (1) Cavernous removal eruptions
   (2) Absent invasion lotion
   (3) Parenthetical rubber
   (4) Strenuous preserves
   (5) Injudicious prescription proportions
Message-Id: <20100408015439.837342719@magilla.sf.frob.com>
Date: Wed,  7 Apr 2010 18:54:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

> Note: this code doesn't need this check and tasklist_lock at all,
> it should be converted to use lock_task_sighand(). And, the code
> under SIGNAL_STOP_STOPPED check looks wrong.

Agreed.  It should match that part of ptrace_untrace().


Thanks,
Roland
