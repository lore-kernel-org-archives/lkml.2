Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2JKUyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab2JKUyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:54:10 -0400
Date: Thu, 11 Oct 2012 22:54:03 +0200
From: Michal Marek <mmarek@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Santos <daniel.santos@pobox.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/10] compiler-gcc4.h: correct verion check for
 __compiletime_error
Message-ID: <20121011205403.GF16465@sepie.suse.cz>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-2-git-send-email-daniel.santos@pobox.com>
 <alpine.DEB.2.00.1210022324430.12717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210022324430.12717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:25:12PM -0700, David Rientjes wrote:
> On Fri, 28 Sep 2012, Daniel Santos wrote:
> 
> > NOTE: this is has already been comitted to -mm
> > 
> > __attribute__((error(msg))) was introduced in gcc 4.3 (not 4.4) and as I
> > was unable to find any gcc bugs pertaining to it, I'm presuming that it
> > has functioned as advertised since 4.3.0.
> > 
> > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Tested-by: David Rientjes <rientjes@google.com>
> 
> Works with 4.3.6.

Applied to kbuild.git#kbuild now.

Michal
