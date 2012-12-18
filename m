Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2LRUgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:36:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2LRUge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:36:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1355860368.30366.33.camel@joe-AO722>
References: <1355860368.30366.33.camel@joe-AO722> <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com> <6433.1355840610@warthog.procyon.org.uk> <12373.1355858223@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on #include <uapi/...
Date: Tue, 18 Dec 2012 20:35:45 +0000
Message-ID: <14276.1355862945@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> No.  I'm confused, I believe your example was:
> 
> arch/powerpc/include/asm/kvm_para.h
> ...
> -#include <linux/types.h>
> +#include <uapi/asm/kvm_para.h>

No, that is a correct alteration.

The example I gave was:

	- #include <asm/epapr_hcalls.h>
	++#include <uapi/asm/epapr_hcalls.h>

which is to be found in arch/powerpc/include/uapi/asm/kvm_para.h.

Sorry for the confusion.

David
