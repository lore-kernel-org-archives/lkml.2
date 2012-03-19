Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2CSXeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:34:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50056 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2CSXeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:34:13 -0400
Date: Mon, 19 Mar 2012 16:34:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: add user-definable alloc/free funcs
Message-ID: <20120319233409.GA16124@kroah.com>
References: <1331931888-14175-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120316213227.GB24556@kroah.com>
 <4F678100.1000707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F678100.1000707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 01:54:56PM -0500, Seth Jennings wrote:
> > I'm sorry, I know this isn't fair for your specific patch, but we have
> > to stop this sometime, and as this patch adds code isn't even used by
> > anyone, its a good of a time as any.
> 
> So, this the my first "promotion from staging" rodeo.  I would love to
> see this code mainlined ASAP.  How would I/we go about doing that?

What subsystem should this code live in?  The -mm code, I'm guessing,
right?  If so, submit it to the linux-mm mailing list for inclusion, you
can point them at what is in drivers/staging right now, or probably it's
easier if you just make a new patch that adds the code that is in
drivers/staging/ to the correct location in the kernel.  That way it's
easier to review and change.  When it finally gets accepted, we can then
delete the drivers/staging code.

hope this helps,

greg k-h
