Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab1KVVjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:39:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab1KVVjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:39:11 -0500
Date: Tue, 22 Nov 2011 13:39:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-Id: <20111122133909.ebe72517.akpm@linux-foundation.org>
In-Reply-To: <1321997538.6445.90.camel@work-vm>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	<20111122125209.7f70f3a7.akpm@linux-foundation.org>
	<1321997538.6445.90.camel@work-vm>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 13:32:18 -0800
John Stultz <john.stultz@linaro.org> wrote:

> Very cool!  Yea. Dave brought up that the list was fairly inefficient,
> but I figured I'd get more feedback on the mechanism before spending too
> much time optimizing the structure. I'll look at your mumbletree code
> and see how it can be adapted. Other then apparently being a nod to the
> "original neo-grunge/indie-rock band from Rochester", is there a story
> to the name? :)

I was first!

I was sure there was some correct term for such a tree in the
literature, but I didn't know what it was and the compiler didn't like
"*_tree".

> Again, I appreciate the feedback! Thanks so much!

I note you sneakily deleted the bit about posix/bsd file locking.
