Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2IDUHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:07:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28671 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab2IDUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:07:49 -0400
Date: Tue, 4 Sep 2012 15:57:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 0/3] promote zcache from staging
Message-ID: <20120904195711.GC12469@phenom.dumpdata.com>
References: <1346788969-4100-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346788969-4100-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:02:46PM -0500, Seth Jennings wrote:
> zcache is the remaining piece of code required to support in-kernel
> memory compression.  The other two features, cleancache and frontswap,
> have been promoted to mainline in 3.0 and 3.5 respectively.  This
> patchset promotes zcache from the staging tree to mainline.

Could you please post it as a singular path. As if it was out-off-tree?
That way it will be much easier to review it by looking at the full code.
