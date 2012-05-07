Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2EGPDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:03:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52390 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2EGPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:03:13 -0400
Message-ID: <4FA7E3D0.2040906@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 10:01:36 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-3-git-send-email-minchan@kernel.org> <4FA28907.9020300@vflare.org> <4FA2A2F0.3030509@linux.vnet.ibm.com> <4FA33DF6.8060107@kernel.org>
In-Reply-To: <4FA33DF6.8060107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050715-5518-0000-0000-000004352BB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 09:24 PM, Minchan Kim wrote:

> On 05/04/2012 12:23 AM, Seth Jennings wrote:
>> The reason I hadn't done it before is that it introduces a checkpatch
>> warning:
>>
>> WARNING: do not add new typedefs
>> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
>> +typedef void * zs_handle;
>>
> 
> 
> Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.
> 
>  (a) totally opaque objects (where the typedef is actively used to _hide_
>      what the object is).
> 
> No?


Interesting, seems like checkpatch and CodingStyle aren't completely in
sync here.  Maybe the warning should say "do not add new typedefs unless
allowed by CodingStyle 5(a)" or something.

Works for me though.

Thanks again Minchan!

--
Seth

