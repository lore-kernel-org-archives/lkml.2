Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab0D3T2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:28:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41940 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab0D3T1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LdHwMNAJAXBSbfJJHaBFgIHXUZk6Duw2sIqxrgA+muMVo7aD7qTVWPLpET/WWF7I0s
         iVDt8/UhJ0yFnzVjNq9f+ZOiKAFe0AEZWdNz6dIhJgpvD9dFJNbCIcnzqugLnSs0cRaB
         9sxrf1ewtvMzsSLAaG5uon2uBipz7r5leIiZg=
Date: Fri, 30 Apr 2010 21:27:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 30
Message-ID: <20100430192748.GC5357@nowhere>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 04:35:38PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100429:
> 
> Dropped trees: tmio-mmc (long unresolved conflicts and unable to fetch)
> 	hwlat (at the maintainer's request)
> 
> My fixes tree contains:
> 	a patch for a pktcdvd build error from Arnd Bergmann
> 
> The v4l-dvb tree still has its build failure, so I used the version from
> next-20100409.
> 
> The block tree lost a conflict and its build failure but gained another
> conflict against the ext3 tree.
> 
> The bk-ioctl tree still has its build failure so I used the version from
> next-20100428.


That looks weird, I fixed all the reported conflicts and build error you
reported. Or may be there are some others left that I missed in allyesconfig?

Thanks.

