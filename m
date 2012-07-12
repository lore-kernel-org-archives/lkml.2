Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab2GLOKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:10:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2GLOKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:10:17 -0400
Message-ID: <1342102195.28010.4.camel@twins>
Subject: Re: [PATCH 00/13] rbtree updates
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        daniel.santos@pobox.com, axboe@kernel.dk, ebiederm@xmission.com,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Thu, 12 Jul 2012 16:09:55 +0200
In-Reply-To: <20120712011208.GA1152@google.com>
References: <1341876923-12469-1-git-send-email-walken@google.com>
	 <1342012996.3462.154.camel@twins> <20120712011208.GA1152@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 18:12 -0700, Michel Lespinasse wrote:
> Do you mean the case you marked XXX ? it is actually parent that is
> red, which we know because we tested that a few lines earlier.
> 
> > @@ -85,12 +104,27 @@ void rb_insert_color(struct rb_node *nod
> >                 } else if (rb_is_black(parent))
> >                         break;
> >
> > +               /*
> > +                * XXX
> > +                */
> >                 gparent = rb_red_parent(parent);
> 
> See :) 

D'0h, I got confused and thought the red was for the parent's parent,
not parent.

Quite.. ignore that then.
