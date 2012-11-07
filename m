Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2KGWik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab2KGWij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:38:39 -0500
Date: Wed, 7 Nov 2012 17:38:30 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: fix shmem_getpage_gfp VM_BUG_ON
Message-ID: <20121107223830.GA12561@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1210242121410.1697@eggly.anvils>
 <20121101191052.GA5884@redhat.com>
 <alpine.LNX.2.00.1211011546090.19377@eggly.anvils>
 <20121101232030.GA25519@redhat.com>
 <alpine.LNX.2.00.1211011627120.19567@eggly.anvils>
 <20121102014336.GA1727@redhat.com>
 <alpine.LNX.2.00.1211021606580.11106@eggly.anvils>
 <alpine.LNX.2.00.1211051729590.963@eggly.anvils>
 <20121106135402.GA3543@redhat.com>
 <alpine.LNX.2.00.1211061521230.6954@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211061521230.6954@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:48:20PM -0800, Hugh Dickins wrote:
 
 > > ------------[ cut here ]------------
 > > WARNING: at mm/shmem.c:1151 shmem_getpage_gfp+0xa5c/0xa70()
 > > Hardware name: 2012 Client Platform
 > > Pid: 21798, comm: trinity-child4 Not tainted 3.7.0-rc4+ #54
 > 
 > That's the very same line number as in your original report, despite
 > the long comment which the patch adds.  Are you sure that kernel was
 > built with the patch in?

I just changed the code by hand, and opted not to paste the comment in.

It is plausible that I built that kernel and forgot to reboot into it,
but I'm 99.9% sure that that wasn't the case.

Unfortunatly I can't check immediately, as that machine for reasons
unknown no longer wants to get past the BIOS POST check.

I'll see if I can reproduce it on a different test box until I get
that one back up.

	Dave

