Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2AIX0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:26:52 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48125 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab2AIX0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:26:50 -0500
Message-ID: <4F0B77AF.1060005@linux.vnet.ibm.com>
Date: Mon, 09 Jan 2012 17:26:39 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] staging: zsmalloc: memory allocator for compressed
 pages
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120109230944.GA11802@suse.de>
In-Reply-To: <20120109230944.GA11802@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12010923-5112-0000-0000-000003E198B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 05:09 PM, Greg KH wrote:
> On Mon, Jan 09, 2012 at 04:51:55PM -0600, Seth Jennings wrote:
>> This patchset introduces a new memory allocation library named
>> zsmalloc.  zsmalloc was designed to fulfill the needs
>> of users where:
>>  1) Memory is constrained, preventing contiguous page allocations
>>     larger than order 0 and
>>  2) Allocations are all/commonly greater than half a page.
> 
> As this is submitted during the merge window, I don't have any time to
> look at it until after 3.3-rc1 is out.
> 
> I'll queue it up for then.

Thanks Greg!

I forgot to specify in the cover letter, this patch is based on
v3.2 PLUS my zv stat fix (https://lkml.org/lkml/2011/12/30/48) 
and crypto API support patch v2 (https://lkml.org/lkml/2012/1/3/263).
Both have been Acked by Dan and Nitin had Acked v1 of the crypto API
support patch. Everything should merge cleanly if applied in that
order.

--
Seth

