Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2I0UZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:25:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43354 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2I0UZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:25:51 -0400
Message-ID: <5064B647.3000906@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 15:25:43 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120921161252.GV11266@suse.de> <20120921180222.GA7220@phenom.dumpdata.com> <505CB9BC.8040905@linux.vnet.ibm.com> <42d62a30-bd6c-4bd7-97d1-bec2f237756b@default> <50609794.8030508@linux.vnet.ibm.com> <b34c65c9-4b25-431d-8b82-cbe911126be9@default>
In-Reply-To: <b34c65c9-4b25-431d-8b82-cbe911126be9@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092720-7182-0000-0000-000002B4D4C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 02:17 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [RFC] mm: add support for zsmalloc and zcache
> 
> Once again, you have completely ignored a reasonable
> compromise proposal.  Why?

We have users who are interested in zcache and we had hoped for a path
that didn't introduce an additional 6-12 month delay.  I am talking
with our team to determine a compromise that resolves this, but also
gets this feature into the hands of users that they can work with.
I'll be away from email until next week, but I wanted to get something
out to the mailing list before I left.  I need a couple days to give a
more definite answer.

Seth


