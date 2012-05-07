Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2EGPPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:15:45 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42967 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2EGPPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:15:43 -0400
Message-ID: <4FA7E6DD.6010607@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 10:14:37 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
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
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050715-3270-0000-0000-00000622A6D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 11:37 AM, Seth Jennings wrote:

> I'll apply your patch and try it out.

Sorry for taking so long.

I finally got around to testing this on an x86_64 VM and it works with
the same performance as before and is much cleaner.  I like it.  Just
need to expand the patch to all the arches.

I'm also interested to see if this works for ppc64.  I'm hoping to try
it out today or tomorrow.

--
Seth

