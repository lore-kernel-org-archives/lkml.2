Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2GFPMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:12:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60215 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GFPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:12:30 -0400
Message-ID: <4FF6FF1F.5090701@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2012 10:07:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] zsmalloc improvements
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120704204325.GB2924@localhost.localdomain>
In-Reply-To: <20120704204325.GB2924@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070615-1780-0000-0000-0000072980D7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00154288; UDB=6.00034809; UTC=2012-07-06
 15:12:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 03:43 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 02, 2012 at 04:15:48PM -0500, Seth Jennings wrote:
>> This exposed an interesting and unexpected result: in all
>> cases that I tried, copying the objects that span pages instead
>> of using the page table to map them, was _always_ faster.  I could
>> not find a case in which the page table mapping method was faster.
> 
> Which architecture was this under? It sounds x86-ish? Is this on
> Westmere and more modern machines? What about Core2 architecture?
> 
> Oh how did it work on AMD Phenom boxes?

I don't have a Phenom box but I have an Athlon X2 I can try out.
I'll get this information next Monday.

--
Seth

