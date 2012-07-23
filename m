Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2GWW3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 18:29:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43835 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab2GWW3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 18:29:05 -0400
Date: Mon, 23 Jul 2012 15:27:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: s/firstpage/page in new copy map funcs
Message-ID: <20120723222749.GA25533@kroah.com>
References: <1342630556-28686-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <500DCBDF.5090800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500DCBDF.5090800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 05:10:39PM -0500, Seth Jennings wrote:
> Greg,
> 
> I know it's the first Monday after a kernel release and
> things are crazy for you.  I was hoping to get this zsmalloc
> stuff in before the merge window hit so I wouldn't have to
> bother you :-/  But, alas, it didn't happen that way.

Nope, sorry, it missed them.  It needed to be at least a week previous
to when the final kernel comes out to get into the next one.

> Minchan acked these yesterday.  When you get a chance, could
> you pull these 3 patches?  I'm wanting to send out a
> promotion patch for zsmalloc and zcache based on these.

Sorry, it will have to wait until after 3.6-rc1 is out before I will add
them to my tree for 3.7, that's the merge rules, that you well know :)

greg k-h
