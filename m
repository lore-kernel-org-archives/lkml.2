Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2FLK1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:27:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:38506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2FLK1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:27:21 -0400
Message-ID: <1339496836.31548.68.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hi3766691@gmail.com, Hillf Danton <dhillf@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Zhouping Liu <zliu@redhat.com>
Date: Tue, 12 Jun 2012 12:27:16 +0200
In-Reply-To: <CA+55aFw=akW7B+vRkQRMojnP6_b1YXdKpNEjQ2EyBHcTe2_XLw@mail.gmail.com>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
	 <1339421268.30462.15.camel@twins> <4FD6BD72.2070808@redhat.com>
	 <1339490988.31548.40.camel@twins>
	 <CA+55aFw=akW7B+vRkQRMojnP6_b1YXdKpNEjQ2EyBHcTe2_XLw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 13:20 +0300, Linus Torvalds wrote:
> Peter, you are very fundamentally wrong if you think the distance
> array has to be symmetric. That is fundamentally not true for many
> typologies.
> 
> The trivial example of a non symmetric case is just a simple
> unidirectional ring. The distance from n to n+1 is just one, but the
> distance from n+1 to n is n-1 hops.
> 
> So don't try to say that distances have to be symmetric. That's just
> garbage. 

Sure, I realize this, but the 17,18 thing isn't a ring. It looks like
something that should be symmetric but isn't.


