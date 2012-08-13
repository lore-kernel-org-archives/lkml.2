Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2HMIUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:20:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:34812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2HMIUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:20:52 -0400
Message-ID: <1344846039.31459.14.camel@twins>
Subject: Re: [PATCH 0/5] rbtree based interval tree as a prio_tree
 replacement
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, vrajesh@umich.edu, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Date: Mon, 13 Aug 2012 10:20:39 +0200
In-Reply-To: <1344324343-3817-1-git-send-email-walken@google.com>
References: <1344324343-3817-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 00:25 -0700, Michel Lespinasse wrote:
> a faster worst-case complexity of O(k+log N) for stabbing queries in a
> well-balanced prio tree, vs O(k*log N) for interval trees (where k=number
> of matches, N=number of intervals). Now this sounds great, but in practice
> prio trees don't realize this theorical benefit. First, the additional
> constraint makes them harder to update, so that the kernel implementation
> has to simplify things by balancing them like a radix tree, which is not
> always ideal. 

Not something spending a great deal of time on, but do you have any idea
what the radix like balancing does the the worst case stabbing
complexity?

Anyway, I like the thing, that prio-tree code always made my head hurt.
