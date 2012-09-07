Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2IGWzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:55:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2IGWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:55:15 -0400
Date: Fri, 7 Sep 2012 15:55:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, riel@redhat.com, peterz@infradead.org,
        aarcange@redhat.com, hughd@google.com, daniel.santos@pobox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: interval tree updates
Message-Id: <20120907155514.3fad7887.akpm@linux-foundation.org>
In-Reply-To: <CANN689HMxteeUT9q5BgKutEnNQF6sKv2n9ze11Z=wkOoC+XGqw@mail.gmail.com>
References: <1346750457-12385-1-git-send-email-walken@google.com>
	<1346750457-12385-2-git-send-email-walken@google.com>
	<20120907151341.79cb5638.akpm@linux-foundation.org>
	<CANN689HMxteeUT9q5BgKutEnNQF6sKv2n9ze11Z=wkOoC+XGqw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2012 15:29:36 -0700
Michel Lespinasse <walken@google.com> wrote:

> > Ho hum.  I don't think I can be bothered untangling all this.
> 
> I don't think you should have to do it yourself either.

Patch wrangling is what I do ;)

> But, if you're willing to take it, I can send you replacement patches for
> (mm-replace-vma-prio_tree-with-an-interval-tree.patch +
> mm-interval-tree-updates.patch) collapsed into one, and
> rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
> fixed so that it'd apply after the collapsed patch (and get to the
> same end state).

Yes please, I suppose we should do this.
