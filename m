Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2I1Nbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:31:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332Ab2I1Nbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:31:35 -0400
Date: Fri, 28 Sep 2012 14:31:21 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC/PATCH] zcache2 on PPC64 (Was: [RFC] mm: add support for
 zsmalloc and zcache)
Message-ID: <20120928133121.GH29125@suse.de>
References: <30a570e8-8157-47e1-867a-4960a7c1173d@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <30a570e8-8157-47e1-867a-4960a7c1173d@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:31:01PM -0700, Dan Magenheimer wrote:
> Attached patch applies to staging-next and I _think_ should
> fix the reported problem where zbud in zcache2 does not
> work on a PPC64 with PAGE_SIZE!=12.  I do not have a machine
> to test this so testing by others would be appreciated.
> 

Seth, can you verify?

-- 
Mel Gorman
SUSE Labs
