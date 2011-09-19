Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1ISTsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:48:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:59565 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1ISTsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,407,1312182000"; 
   d="scan'208";a="50562537"
Date: Mon, 19 Sep 2011 20:55:41 +0100
From: Alan Cox <alan@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to
 /proc/slabinfo
Message-ID: <20110919205541.1c44f1a3@bob.linux.org.uk>
In-Reply-To: <14082.1316461507@turing-police.cc.vt.edu>
References: <20110910164001.GA2342@albatros>
	<20110910164134.GA2442@albatros>
	<20110914192744.GC4529@outflux.net>
	<20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
	<14082.1316461507@turing-police.cc.vt.edu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 15:45:07 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 19 Sep 2011 18:46:58 +0400, Vasiliy Kulikov said:
> 
> > One note: only to _kernel_ developers.  It means it is a strictly
> > debugging feature, which shouldn't be enabled in the production
> > systems.
> 
> Until somebody at vendor support says "What does 'cat /proc/slabinfo'
> say?"
> 
> Anybody who thinks that debugging tools should be totally disabled on
> "production" systems probably hasn't spent enough time actually
> running production systems.

Agreed - far better it is simply set root only. At that point if you
can read it you've bypassed DAC anyway so either you already control
the box or something like SELinux or SMACK is in the way in which case
*it* can manage extra policy just fine.
