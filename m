Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1FCBft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:35:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2441 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab1FCBfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:35:47 -0400
Subject: Re: [TRIVIAL PATCH next 15/15] net: Convert vmalloc/memset to
 vzalloc
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: pablo@netfilter.org, kaber@trash.net, andy.grover@oracle.com,
        trivial@kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rds-devel@oss.oracle.com
In-Reply-To: <20110602.143927.1073346459383432955.davem@davemloft.net>
References: <cover.1306603968.git.joe@perches.com>
	 <045996b9688bfaa2efbd8999405a67e23cd0a075.1306603968.git.joe@perches.com>
	 <4DE7A311.5000406@netfilter.org>
	 <20110602.143927.1073346459383432955.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 18:35:44 -0700
Message-ID: <1307064945.14598.14.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 14:39 -0700, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Thu, 02 Jun 2011 16:49:53 +0200
> > Are you going to take this patch? it includes one chunk which is out of
> > netfilter scope.
> I think the trivial folks submit these things via their own tree
> and are only looking for ACKs from us.
> Acked-by: David S. Miller <davem@davemloft.net>

Getting trivial patches applied between the various
maintainers and the trivial tree is most often a bit
uncoordinated and haphazard.

Doing micropatches for each subsystem maintainer
does sometimes appear to be detrimental to getting
any treewide modification applied.

I've experimented with both micropatches and
treewide patches to gauge what happens.
I'm not sure either approach is better or worse.

In any case, it commonly takes several submittals
for these sort of trivial patches to get applied
either by the subtree maintainer or by Jiri.

Jiri often waits a few weeks for patches to get
picked up by any subtree maintainer before looking
at his trivial emails.  Sometimes he acks what's
left, sometimes what's left just disappears into
the ethervoid waiting for the submitter to try
again.

No worries, that's just the way it is.


