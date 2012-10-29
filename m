Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab2J2N7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:59:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2J2N7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:59:03 -0400
Date: Mon, 29 Oct 2012 09:44:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        acme@ghostprotocols.net, walken@google.com, akpm@linux-foundation.org
Subject: Re: make DESTDIR=something -C linux/tools O=<somewhere>/tools
 perf_install fails during compile - ../../lib/rbtree.c:24:36: error:
 linux/rbtree_augmented.h ?
Message-ID: <20121029134445.GU2708@phenom.dumpdata.com>
References: <20121012133719.GA7169@phenom.dumpdata.com>
 <20121024103234.GA10691@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024103234.GA10691@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:32:34PM +0200, Ingo Molnar wrote:
> 
> * Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > Hey Ingo, Andrew, Michel, etc.
> > 
> > Was wondering if you had seen similar errors? I am building perf out-of-tree
> > (so using the O= and -C combination). This did used to work in v3.6.
> > 
> > It looks like the libtree_augmented.h is missing somehow?
> 
> It's working for me now - can you confirm that it's all fixed in 
> Linus's latest tree?

Yes. Thx!
> 
> Thanks,
> 
> 	Ingo
