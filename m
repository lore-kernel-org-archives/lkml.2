Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2GWALK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:11:10 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53141 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GWALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:11:08 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-fa-500c969ac0d3
Date: Mon, 23 Jul 2012 09:11:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: s/firstpage/page in new copy map funcs
Message-ID: <20120723001123.GA4037@bbox>
References: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:55:54AM -0500, Seth Jennings wrote:
> firstpage already has precedent and meaning the first page
> of a zspage.  In the case of the copy mapping functions,
> it is the first of a pair of pages needing to be mapped.
> 
> This patch just renames the firstpage argument to "page" to
> avoid confusion.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
