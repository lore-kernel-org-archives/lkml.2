Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1ILX4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:56:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1ILX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:56:11 -0400
Date: Mon, 12 Sep 2011 19:56:05 -0400
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Documentation/memory-barriers.txt
Message-ID: <20110912235605.GA12886@synalogic.ca>
References: <20110912141520.GA18647@synalogic.ca>
 <20110912163307.GC2362@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912163307.GC2362@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-12 09:33, Paul E. McKenney wrote:
> On Mon, Sep 12, 2011 at 10:15:20AM -0400, Benjamin Poirier wrote:
> > Hello David, Paul,
> > 
[snip]
> 
> This example would be correct for a looping case, but is more ornate than
> required for illustrating the effects of memory barriers.  So we took the
> simpler case without the loop.

Thanks for the clarification. I was under the false impression that all
of the code examples in this section represented the same code segment
that was modified from one example to the next. In any case, these
examples do demonstrate the use of memory barriers clearly.

-Ben
