Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2JDX2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:28:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35928 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab2JDX2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:28:47 -0400
Date: Fri, 5 Oct 2012 01:28:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikola Pajkovsky <npajkovs@redhat.com>
Subject: Re: [ 147/180] udf: Fortify loading of sparing table
Message-ID: <20121004232839.GB16406@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225203.841869825@1wt.eu> <20121004231557.GM13292@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004231557.GM13292@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 12:15:57AM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:54:24AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit 1df2ae31c724e57be9d7ac00d78db8a5dabdd050 upstream.
> > 
> > Add sanity checks when loading sparing table from disk to avoid accessing
> > unallocated memory or writing to it.
> [...]
> 
> It looks like commit 68766a2edcd5cd744262a70a2f67a320ac944760 should
> be added after this.

Thanks, queued!

Willy

