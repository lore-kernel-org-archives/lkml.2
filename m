Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2LRWOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:14:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48556 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754203Ab2LRWOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:14:52 -0500
Message-ID: <1355868892.3982.6.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on #include <uapi/...
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 14:14:52 -0800
In-Reply-To: <14276.1355862945@warthog.procyon.org.uk>
References: <1355860368.30366.33.camel@joe-AO722>
	 <9cfc0861cd3ae0a7d4e72056c00b8bebef1490eb.1355853060.git.joe@perches.com>
	 <6433.1355840610@warthog.procyon.org.uk>
	 <12373.1355858223@warthog.procyon.org.uk>
	 <14276.1355862945@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 20:35 +0000, David Howells wrote:
> Joe Perches <joe@perches.com> wrote:
[]
> > arch/powerpc/include/asm/kvm_para.h
> > ...
> > -#include <linux/types.h>
> > +#include <uapi/asm/kvm_para.h>
> 
> No, that is a correct alteration.
> 
> The example I gave was:
> 
> 	- #include <asm/epapr_hcalls.h>
> 	++#include <uapi/asm/epapr_hcalls.h>
> 
> which is to be found in arch/powerpc/include/uapi/asm/kvm_para.h.

Just to verify, any file in any path [.../]include/uapi/...
should not itself have a line like '#include <uapi/...' ?


