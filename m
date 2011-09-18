Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1IRRFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:05:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1IRRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:05:48 -0400
Date: Sun, 18 Sep 2011 21:05:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
Message-ID: <20110918170512.GA2351@albatros>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
 <20110914192744.GC4529@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914192744.GC4529@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, Sep 14, 2011 at 12:27 -0700, Kees Cook wrote:
> On Sat, Sep 10, 2011 at 08:41:34PM +0400, Vasiliy Kulikov wrote:
> > Historically /proc/slabinfo has 0444 permissions and is accessible to
> > the world.  slabinfo contains rather private information related both to
> > the kernel and userspace tasks.  Depending on the situation, it might
> > reveal either private information per se or information useful to make
> > another targeted attack.  Some examples of what can be learned by
> > reading/watching for /proc/slabinfo entries:
> > ...
> > World readable slabinfo simplifies kernel developers' job of debugging
> > kernel bugs (e.g. memleaks), but I believe it does more harm than
> > benefits.  For most users 0444 slabinfo is an unreasonable attack vector.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> Haven't had any mass complaints about the 0400 in Ubuntu (sorry Dave!), so
> I'm obviously for it.
> 
> Reviewed-by: Kees Cook <kees@ubuntu.com>

Looks like the members of the previous slabinfo discussion don't object
against the patch now and it got two other Reviewed-by responses.  Can
you merge it as-is or should I probably convince someone else?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
