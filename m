Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2JKHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:43:17 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43077 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab2JKHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:43:14 -0400
Date: Thu, 11 Oct 2012 09:42:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Mel Gorman <mgorman@suse.de>, linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
 s390
Message-ID: <20121011094257.61a9a460@mschwide>
In-Reply-To: <alpine.LSU.2.00.1210101402310.1939@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009162107.GE15790@quack.suse.cz>
	<alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
	<20121010085524.GA32581@quack.suse.cz>
	<alpine.LSU.2.00.1210101402310.1939@eggly.anvils>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12101107-2966-0000-0000-00000584125F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 14:28:32 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> But perhaps these machines aren't much into heavy swapping.  Now, 
> if Martin would send me a nice little zSeries netbook for Xmas,
> I could then test that end of it myself ;)

Are you sure about that? The electricity cost alone for such a beast
is quite high ;-)

> I've just arrived at the conclusion that page migration does _not_
> have a problem with transferring the dirty storage key: I had been
> thinking that your testing might stumble on that issue, and need a
> further patch, but I'll explain in other mail why now I think not.

That is good to know, one problem less on the list.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

