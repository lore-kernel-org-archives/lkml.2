Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0DSDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 23:09:59 -0400
Received: from thunk.org ([69.25.196.29]:38417 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0DSDJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 23:09:57 -0400
Date: Sun, 18 Apr 2010 23:08:51 -0400
From: tytso@mit.edu
To: James Bottomley <James.Bottomley@suse.de>
Cc: Sorin Faibish <sfaibish@emc.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100419030851.GA6344@thunk.org>
Mail-Followup-To: tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>,
	Sorin Faibish <sfaibish@emc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20100414155233.D153.A69D9226@jp.fujitsu.com>
 <20100414072830.GK2493@dastard>
 <20100414085132.GJ25756@csn.ul.ie>
 <20100415013436.GO2493@dastard>
 <20100415102837.GB10966@csn.ul.ie>
 <20100416041412.GY2493@dastard>
 <20100416151403.GM19264@csn.ul.ie>
 <20100417203239.dda79e88.akpm@linux-foundation.org>
 <op.vbdgq3hhrwwil4@sfaibish1.corp.emc.com>
 <1271626236.27350.70.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271626236.27350.70.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 18, 2010 at 04:30:36PM -0500, James Bottomley wrote:
> > I for one am looking very seriously at this problem together with Bruce.
> > We plan to have a discussion on this topic at the next LSF meeting
> > in Boston.
> 
> As luck would have it, the Memory Management summit is co-located with
> the Storage and Filesystem workshop ... how about just planning to lock
> all the protagonists in a room if it's not solved by August.  The less
> extreme might even like to propose topics for the plenary sessions ...

I'd personally hope that this is solved long before the LSF/VM
workshops.... but if not, yes, we should definitely tackle it then.

      	     	       	  	 	    	   - Ted
