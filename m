Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1GVSXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1GVSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:23:37 -0400
Date: Fri, 22 Jul 2011 20:20:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [GIT PULL] ptrace changes for v3.1
Message-ID: <20110722182018.GA18447@redhat.com>
References: <20110722173237.GA16787@redhat.com> <20110722180312.GA744@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722180312.GA744@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Evgeniy)

On 07/22, Christoph Hellwig wrote:
>
> On Fri, Jul 22, 2011 at 07:32:37PM +0200, Oleg Nesterov wrote:
> > 	- f701e5b7 "connector: add an event for monitoring process tracers" is
> > 	  a bit off-topic, it was routed via ptrace branch because it textually
> > 	  depends on the changes in tracehook/ptrace_attach code.
>
> Please do not actually add anything to the connector code.  It's a
> horrible interface and users should migrate away from it.

I never understood who can use this interface and for what.
But it has users.

As for this patch. This feature was acked by maintainers,
I do not think I can argue. Fortunately, the patch adds nothing
without CONFIG_PROC_EVENTS.

Oleg.

