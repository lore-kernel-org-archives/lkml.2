Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab2IDULP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:11:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab2IDULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:11:13 -0400
Date: Tue, 4 Sep 2012 13:11:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 0/3] promote zcache from staging
Message-Id: <20120904131110.5cecf34a.akpm@linux-foundation.org>
In-Reply-To: <20120904195711.GC12469@phenom.dumpdata.com>
References: <1346788969-4100-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<20120904195711.GC12469@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 15:57:11 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Tue, Sep 04, 2012 at 03:02:46PM -0500, Seth Jennings wrote:
> > zcache is the remaining piece of code required to support in-kernel
> > memory compression.  The other two features, cleancache and frontswap,
> > have been promoted to mainline in 3.0 and 3.5 respectively.  This
> > patchset promotes zcache from the staging tree to mainline.
> 
> Could you please post it as a singular path. As if it was out-off-tree?
> That way it will be much easier to review it by looking at the full code.

Yes please.  Very few of the MM developers are familiar with this code.
