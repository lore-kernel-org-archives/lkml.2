Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1FRBwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 21:52:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1FRBww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 21:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=iPE1R814K2nttX0GrHSecgn3W3upQBXV4HVRvqbgdUuSuDphBHRS++0+h37v873HsE
         6JZn89A6jtPGC61eIleg==
Date: Fri, 17 Jun 2011 18:52:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Randy Dunlap <rdunlap@xenotime.net>
cc: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <20110617171228.4c85fd38.rdunlap@xenotime.net>
Message-ID: <alpine.LSU.2.00.1106171845480.20321@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <20110617163854.49225203.akpm@linux-foundation.org> <20110617170742.282a1bd6.rdunlap@xenotime.net>
 <20110617171228.4c85fd38.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Randy Dunlap wrote:
> > 
> > And regardless of the patch path that is taken, update test(s) if
> > applicable.

Thanks for the links, Randy, I hadn't thought of those at all.

> > I thought that someone from Red Hat had a kernel loadable
> > module for testing radix-tree -- or maybe that was for rbtree (?) --
> > but I can't find that just now.
> 
> http://people.redhat.com/jmoyer/radix-tree/

This one just tests that radix_tree_preload() goes deep enough:
not affected by the little change I've made.

> > And one Andrew Morton has a userspace radix tree test harness at
> > http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz

This should still be as relevant as it was before, but I notice its
radix_tree.c is almost identical to the source currently in the kernel
tree, so I ought at the least to keep it in synch.

Whether there's anything suitable for testing here in the changes that
I've made, I'll have to look into later.

Hugh
