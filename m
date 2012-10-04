Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2JDXQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:16:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab2JDXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:16:01 -0400
Date: Fri, 5 Oct 2012 00:15:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikola Pajkovsky <npajkovs@redhat.com>
Message-ID: <20121004231557.GM13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225203.841869825@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225203.841869825@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 147/180] udf: Fortify loading of sparing table
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:54:24AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.
> 
> Add sanity checks when loading sparing table from disk to avoid accessing
> unallocated memory or writing to it.
[...]

It looks like commit 68766a2edcd5cd744262a70a2f67a320ac944760 should
be added after this.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
