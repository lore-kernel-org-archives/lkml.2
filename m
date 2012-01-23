Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2AWO2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:28:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53591 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2AWO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:28:04 -0500
Message-ID: <4F1D6E44.6070509@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 08:27:16 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] staging: zsmalloc: memory allocator for compressed
 pages
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120120140344.2fb399e4.akpm@linux-foundation.org>
In-Reply-To: <20120120140344.2fb399e4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012314-7408-0000-0000-000002187ECF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

Thanks for the feedback.

On 01/20/2012 04:03 PM, Andrew Morton wrote:
> On Mon,  9 Jan 2012 16:51:55 -0600
> Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> 
> The changelog doesn't really describe why the code was written and
> provides no reason for anyone to merge it. <snip>  This is the most important
> part of the patch description and you completely omitted it!

Sorry about that.  The purpose is to replace the xvmalloc allocator
that both zcache and zram use that suffers from the high fragmentation
described.  I 'll be sure to add this to the cover letter.

I was thinking it would go to lib after staging.

Thanks,
--
Seth

