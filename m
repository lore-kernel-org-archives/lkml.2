Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1GSWhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:37:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1GSWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:37:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ktmNfaQkMe1kpR3kl6wnNIGSTWhpuY8FTM1aJx1crNvZ/cI0NueIKLeZSCzexgaQ0
	H4lEjXmty2Ph+0pzn0Psw==
Date: Tue, 19 Jul 2011 15:36:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Randy Dunlap <rdunlap@xenotime.net>
cc: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <alpine.LSU.2.00.1106171845480.20321@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107191532130.1541@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <20110617163854.49225203.akpm@linux-foundation.org> <20110617170742.282a1bd6.rdunlap@xenotime.net> <20110617171228.4c85fd38.rdunlap@xenotime.net>
 <alpine.LSU.2.00.1106171845480.20321@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Hugh Dickins wrote:
> On Fri, 17 Jun 2011, Randy Dunlap wrote:
> 
> > > And one Andrew Morton has a userspace radix tree test harness at
> > > http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz
> 
> This should still be as relevant as it was before, but I notice its
> radix_tree.c is almost identical to the source currently in the kernel
> tree, so I ought at the least to keep it in synch.

I was hoping to have dealt with this by now, Randy; but after downloading
an up-to-date urcu, I'm finding what's currently in rtth does not build
with it.  Unlikely to be hard to fix, but means I'll have to defer it a
little while longer.

Hugh
