Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1HXPTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:19:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1HXPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:19:33 -0400
Date: Wed, 24 Aug 2011 17:16:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
	(ptrace tree related)
Message-ID: <20110824151631.GA11827@redhat.com>
References: <20110823160309.112ad0f4922be8605b61c8dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823160309.112ad0f4922be8605b61c8dd@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

sorry for delay.

On 08/23, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>
> kernel/signal.c: In function 'block_sigmask':
> kernel/signal.c:2333:26: error: 'SA_NODEFER' undeclared (first use in this function)
>
> Caused by commit 932e5a25b9cf ("signal: Add block_sigmask() for adding
> sigmask to current->blocked").

Yes. My bad. I've reset this commit.

> Sparc seems to use SA_NOMASK in the
> equivalent bit of code and has no SA_NODEFER definition.

Yes, I'll push the updated patch(es).


Thanks!

Oleg.

