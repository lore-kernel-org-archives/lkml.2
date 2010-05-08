Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0EHQJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:09:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0EHQJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:09:38 -0400
Date: Sat, 8 May 2010 18:08:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH -tip 1/2] [RESEND] kprobes: Move enable/disable_kprobe()
 out	from debugfs code
Message-ID: <20100508160856.GA29638@elte.hu>
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
 <4BE585D1.50101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE585D1.50101@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
> > Move enable/disable_kprobe() API out from debugfs related code,
> > because these interfaces are not related to debugfs interface.
> 
> Hi Ingo,
> 
> Could you also merge this fix too?
> This fixes a compiler warning when CONFIG_KPROBES && !CONFIG_DEBUG_FS.

Sure, i've applied it to the v2.6.35 queue.

	Ingo
