Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2EHArB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 20:47:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49220 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2EHArA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 20:47:00 -0400
X-AuditID: 9c930179-b7c19ae000000486-4a-4fa86cffd7eb
Message-ID: <4FA86CFE.5080603@kernel.org>
Date: Tue, 08 May 2012 09:46:54 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] zsmalloc: make zsmalloc portable
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-7-git-send-email-minchan@kernel.org> <4F980AFE.60901@vflare.org> <4F982862.4050302@linux.vnet.ibm.com> <4FA7E6DD.6010607@linux.vnet.ibm.com>
In-Reply-To: <4FA7E6DD.6010607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 12:14 AM, Seth Jennings wrote:

> On 04/25/2012 11:37 AM, Seth Jennings wrote:
> 
>> I'll apply your patch and try it out.
> 
> Sorry for taking so long.
> 
> I finally got around to testing this on an x86_64 VM and it works with
> the same performance as before and is much cleaner.  I like it.  Just

> need to expand the patch to all the arches.

> 
> I'm also interested to see if this works for ppc64.  I'm hoping to try
> it out today or tomorrow.


I will have a time to make a patch in a weekend if other urgent doesn't
catch me. :)

Seth, Thanks for the testing!

> 
> --
> Seth
> 



-- 
Kind regards,
Minchan Kim
