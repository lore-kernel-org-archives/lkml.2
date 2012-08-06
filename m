Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2HFU6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:58:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:37070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2HFU6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:58:33 -0400
Message-ID: <1344286699.27828.115.camel@twins>
Subject: Re: [PATCH v2 6/9] rbtree: low level optimizations in rb_erase()
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 22:58:19 +0200
In-Reply-To: <CANN689Gcca_Xr8GQSjJads8psz3PZpya+s8aWTt_goVt0+O4YA@mail.gmail.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-7-git-send-email-walken@google.com>
	 <1344262863.27828.56.camel@twins>
	 <CANN689Gcca_Xr8GQSjJads8psz3PZpya+s8aWTt_goVt0+O4YA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 13:50 -0700, Michel Lespinasse wrote:
> On Mon, Aug 6, 2012 at 7:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> >> +                       /* Case 3: node's successor is leftmost under its
> >> +                        * right child subtree
> >
> > Hmm?
> 
> Would 'leftmost under node's right child subtree' make more sense ?

Nah, its the comment style discrepancy..

 /*
  * Case 3: ....


