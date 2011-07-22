Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1GVTQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:16:16 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:33434 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754584Ab1GVTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:16:15 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 15:16:15 EDT
Date: Fri, 22 Jul 2011 23:07:24 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ptrace changes for v3.1
Message-ID: <20110722190724.GA26835@ioremap.net>
References: <20110722173237.GA16787@redhat.com>
 <20110722180312.GA744@infradead.org>
 <20110722182018.GA18447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722182018.GA18447@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 08:20:18PM +0200, Oleg Nesterov (oleg@redhat.com) wrote:
> On 07/22, Christoph Hellwig wrote:
> >
> > On Fri, Jul 22, 2011 at 07:32:37PM +0200, Oleg Nesterov wrote:
> > > 	- f701e5b7 "connector: add an event for monitoring process tracers" is
> > > 	  a bit off-topic, it was routed via ptrace branch because it textually
> > > 	  depends on the changes in tracehook/ptrace_attach code.
> >
> > Please do not actually add anything to the connector code.  It's a
> > horrible interface and users should migrate away from it.

Besides usual drugs, what else this is all about?

-- 
	Evgeniy Polyakov
