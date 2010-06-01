Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab0FAQCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:02:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0FAQCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:02:24 -0400
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <1275408030.27810.27637.camel@twins>
References: <20100601073343.GQ9453@laptop>
	 <1275408030.27810.27637.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 18:02:24 +0200
Message-ID: <1275408144.27810.27644.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 18:00 +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-01 at 17:33 +1000, Nick Piggin wrote:
> > +       sd->iter = iter->next;
> 
> BTW, the (utter lack of) synchronization of sd->iter probably wants a
> comment somewhere ;-)

serialization that is,..

/me goes brew more tea
