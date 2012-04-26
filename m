Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2DZCEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:04:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46133 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2DZCEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:04:00 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-88-4f98ad08828c
Message-ID: <4F98AD2D.3070900@kernel.org>
Date: Thu, 26 Apr 2012 11:04:29 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] zsmalloc: make zsmalloc portable
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-7-git-send-email-minchan@kernel.org> <4F980AFE.60901@vflare.org> <4F982862.4050302@linux.vnet.ibm.com>
In-Reply-To: <4F982862.4050302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 01:37 AM, Seth Jennings wrote:

> Hey Minchan,
> 
> Thanks for the patches!
> 
> On 04/25/2012 09:32 AM, Nitin Gupta wrote:
>> I think Seth was working on this improvement but not sure about the
>> current status. Seth?
> 
> Yes, I looked at this option, and it is very clean and portable.
> 
> Unfortunately, IIRC, with our rate of mapping/unmapping,
> flush_tlb_kernel_range() causes an IPI storm that effective
> stalls the machine.
> 
> I'll apply your patch and try it out.


Seth, Thanks!

-- 
Kind regards,
Minchan Kim
