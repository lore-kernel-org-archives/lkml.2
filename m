Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1KNMWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 07:22:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1KNMWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 07:22:13 -0500
Date: Mon, 14 Nov 2011 13:23:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] mm: more intensive memory corruption debug
Message-ID: <20111114122319.GC2513@redhat.com>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
 <1321014994-2426-2-git-send-email-sgruszka@redhat.com>
 <20111111142953.GM3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111142953.GM3083@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 02:29:53PM +0000, Mel Gorman wrote:
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -4,6 +4,7 @@ config DEBUG_PAGEALLOC
> >  	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
> >  	depends on !KMEMCHECK
> >  	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > +	select WANT_PAGE_DEBUG_FLAGS
> 
> Why not add PAGE_CORRUPT (or preferably PAGE_GUARD) in the same pattern
> as PAGE_POISONING already uses?

Additional CONFIG_PAGE_GUARD variable, would be duplicate of
CONFIG_DEBUG_PAGEALLOC. PAGE_POISONING is needed for compile
another file, no such thing would be needed with PAGE_GUARD,
hence I'm consider such variable useless.

Stanislaw
