Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1BGBnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:43:45 -0500
Received: from kroah.org ([198.145.64.141]:59514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1BGBno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:43:44 -0500
Date: Sun, 6 Feb 2011 17:42:05 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 3/4]Define memory_block_size_bytes for powerpc/pseries
Message-ID: <20110207014205.GA16217@kroah.com>
References: <4D386498.9080201@austin.ibm.com>
 <4D3866A0.6010803@austin.ibm.com>
 <1297035563.14982.15.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297035563.14982.15.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 10:39:23AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2011-01-20 at 10:45 -0600, Nathan Fontenot wrote:
> > Define a version of memory_block_size_bytes() for powerpc/pseries such that
> > a memory block spans an entire lmb.
> > 
> > Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> > Reviewed-by: Robin Holt <holt@sgi.com>
> 
> Hi Nathan !
> 
> Is somebody from -mm picking the rest of the series ? This patch as well
> or shall I wait for the first two to go in and then pick that one in
> -powerpc ?

I took all of these in my tree already, is that ok?

thanks,

greg k-h
