Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0CXU7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:59:50 -0400
Received: from tex.lwn.net ([70.33.254.29]:50673 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab0CXU7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:59:49 -0400
Date: Wed, 24 Mar 2010 14:59:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-ID: <20100324145946.372f3f31@bike.lwn.net>
In-Reply-To: <20100324133347.9b4b2789.akpm@linux-foundation.org>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	<20100324133347.9b4b2789.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 13:33:47 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	VM_BUG_ON(cc == NULL);  
> 
> It's a bit strange to test this when we're about to oops anyway.  The
> oops will tell us the same thing.

...except that we've seen a fair number of null pointer dereference
exploits that have told us something altogether different.  Are we
*sure* we don't want to test for null pointers...?

jon
