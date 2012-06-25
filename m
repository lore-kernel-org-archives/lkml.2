Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2FYOLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:11:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51050 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab2FYOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:11:50 -0400
Date: Mon, 25 Jun 2012 07:11:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in
 atomic context
Message-ID: <20120625141145.GA32567@kroah.com>
References: <4FE0392E.3090300@linux.vnet.ibm.com>
 <4FE36D32.3030408@linux.vnet.ibm.com>
 <20120623030052.GA18440@kroah.com>
 <4FE86C1D.2020302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE86C1D.2020302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 08:48:13AM -0500, Seth Jennings wrote:
> On 06/22/2012 10:00 PM, Greg Kroah-Hartman wrote:
> > On Thu, Jun 21, 2012 at 01:51:30PM -0500, Seth Jennings wrote:
> >> I just noticed you sent this patchset to Andrew, but the
> >> staging tree is maintained by Greg.  You're going to want to
> >> send these patches to him.
> >>
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > After this series is redone, right?  As it is, this submission didn't
> > look ok, so I'm hoping a second round is forthcoming...
> 
> Yes. That is the cleanest way since there are dependencies
> among the patches.  You could pull 04-08 and be ok, but you
> might just prefer a repost.

I do prefer a repost, thanks.

greg k-h
