Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1CAMqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 07:46:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:50234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1CAMqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 07:46:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,246,1297065600"; 
   d="scan'208";a="714650684"
Date: Tue, 1 Mar 2011 12:24:37 +0000
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: gma500: Rip out the memory manager
Message-ID: <20110301122437.4477fa65@bob.linux.org.uk>
In-Reply-To: <20110301020302.GA11353@kroah.com>
References: <20110224162440.27093.80825.stgit@localhost.localdomain>
	<20110224162457.27093.32399.stgit@localhost.localdomain>
	<20110301020302.GA11353@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 18:03:02 -0800
Greg KH <greg@kroah.com> wrote:

> On Thu, Feb 24, 2011 at 04:25:09PM +0000, Alan Cox wrote:
> > At this point we simply stuff the display at the start of the
> > stolen memory area that the BIOS gave us. No user framebuffers no
> > multiple framebuffers.
> > 
> > However from here we have a better chance of seeing what is going
> > on and writing an actual gem manager for the driver.
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> This doesn't apply.
> 
> The 1/2 patch had some fuzz in the Makefile, which I fixed up by hand,
> but it makes me think that you are diffing this against some different
> tree.

I've investigated this. The cause seems to be a patch

commit 5352161fc449d7a7573b2e13bd02162aae7aeb69

applied by yourself which cleaned up all sorts of random whitespace
noise and broke further patch application. Given that this is staging
and random whitespace is less important than actually fixing the code I
think the fix is to revert that commit and then apply mine.

Alan
