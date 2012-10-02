Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2JBQLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:11:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42854 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab2JBQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:11:20 -0400
Message-ID: <506B121E.8090307@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 11:11:10 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
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
References: <30a570e8-8157-47e1-867a-4960a7c1173d@default> <20120928133121.GH29125@suse.de>
In-Reply-To: <20120928133121.GH29125@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12100216-7182-0000-0000-000002BA78E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 08:31 AM, Mel Gorman wrote:
> On Tue, Sep 25, 2012 at 04:31:01PM -0700, Dan Magenheimer wrote:
>> Attached patch applies to staging-next and I _think_ should
>> fix the reported problem where zbud in zcache2 does not
>> work on a PPC64 with PAGE_SIZE!=12.  I do not have a machine
>> to test this so testing by others would be appreciated.
>>
> 
> Seth, can you verify?

Yes, this patch does prevent the crash on PPC64.

Seth

