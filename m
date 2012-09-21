Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2IUTQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:16:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44908 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab2IUTQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:16:32 -0400
Message-ID: <505CBD05.8080005@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 14:16:21 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120921161252.GV11266@suse.de>
In-Reply-To: <20120921161252.GV11266@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12092119-6078-0000-0000-00000FDA1FF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 11:12 AM, Mel Gorman wrote:
> That said, my initial feeling still stands. I think that this needs to move
> out of staging because it's in limbo where it is but Andrew may disagree
> because of the reservations. If my reservations are accurate then they
> should at least be *clearly* documented with a note saying that using
> this in production is ill-advised for now. If zcache is activated via the
> kernel parameter, it should print a big dirty warning that the feature is
> still experiemental and leave that warning there until all the issues are
> addressed. Right now I'm not convinced this is production ready but that
> the  issues could be fixed incrementally.

Thank you _so_ much for the review!  Your comments have
provided one of the few glimpses I've had into any other
thoughts on the code save Dan and my own.

I'm in the process of going through the comments you provided.

I am _very_ glad to hear you believe that zcache should be
promoted out of the staging limbo where it currently
resides.  I am fine with providing a warning against use in
production environments until we can address everyone's
concerns.

Once zcache is promoted, I think it will give the code more
opportunity to be used/improved/extended in an incremental
and stable way.

--
Seth

