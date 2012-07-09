Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2GIN6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:58:35 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56568 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab2GIN6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:58:34 -0400
Message-ID: <4FFAE37F.70403@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 08:58:23 -0500
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
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120704204325.GB2924@localhost.localdomain> <4FF6FF1F.5090701@linux.vnet.ibm.com>
In-Reply-To: <4FF6FF1F.5090701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070913-7182-0000-0000-000001EFE7B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 10:07 AM, Seth Jennings wrote:
> On 07/04/2012 03:43 PM, Konrad Rzeszutek Wilk wrote:
>> On Mon, Jul 02, 2012 at 04:15:48PM -0500, Seth Jennings wrote:
>>> This exposed an interesting and unexpected result: in all
>>> cases that I tried, copying the objects that span pages instead
>>> of using the page table to map them, was _always_ faster.  I could
>>> not find a case in which the page table mapping method was faster.
>>
>> Which architecture was this under? It sounds x86-ish? Is this on
>> Westmere and more modern machines? What about Core2 architecture?
>>
>> Oh how did it work on AMD Phenom boxes?
> 
> I don't have a Phenom box but I have an Athlon X2 I can try out.
> I'll get this information next Monday.

Actually, I'm running some production stuff on that box, so
I rather not put testing stuff on it.  Is there any
particular reason that you wanted this information? Do you
have a reason to believe that mapping will be faster than
copy for AMD procs?

(To everyone) I'd like to get this acked before the 3.6
merge window if there are no concerns/objections.

Thanks,
Seth

