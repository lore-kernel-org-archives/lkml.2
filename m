Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2LCMrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 07:47:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2LCMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:47:02 -0500
Date: Mon, 3 Dec 2012 10:46:54 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 026/270] powerpc/eeh: Lock module while handling EEH event
Message-ID: <20121203124653.GA3268@herton-Z68MA-D2H-B3>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-27-git-send-email-herton.krzesinski@canonical.com>
 <1353982714.4266.36.camel@deadeye.wl.decadent.org.uk>
 <20121130014112.GC13478@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130014112.GC13478@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 05:41:12PM -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 27, 2012 at 02:18:34AM +0000, Ben Hutchings wrote:
> > [...]
> > 
> > Greg, you probably want this in 3.4 and 3.6.
> 
> Many thanks.  Herton, any reason why you didn't forward on this
> backported version of the patch?

No specific reason, I just didn't have time to go through verifying
other releases and see what was applied or not, and point out the
specific patches needed in other releases.

> 
> greg k-h
> 

-- 
[]'s
Herton
