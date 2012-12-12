Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2LLR3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:29:02 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40119 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2LLR3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:29:00 -0500
MIME-Version: 1.0
Message-ID: <59a1d7ee-e5dc-4923-8544-605c35c632af@default>
Date: Wed, 12 Dec 2012 09:27:55 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 0/8] zswap: compressed swap caching
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20121211220148.GA12821@kroah.com> <50C8B0EA.6040205@linux.vnet.ibm.com>
In-Reply-To: <50C8B0EA.6040205@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 0/8] zswap: compressed swap caching
> 
> On 12/11/2012 04:01 PM, Greg Kroah-Hartman wrote:
> > On Tue, Dec 11, 2012 at 03:55:58PM -0600, Seth Jennings wrote:
> >> Zswap Overview:
> >
> > <snip>
> >
> > Why are you sending this right at the start of the merge window, when
> > all of the people who need to review it are swamped with other work?
> 
> Yes, sorry, poor timing :-/
> 
> I'm just looking for early feedback from those that are not swamped
> doing merge window stuff.

Hi Seth --

Related, are you now comfortable with abandoning "zcache1" and
moving "zcache2" (now in drivers/staging/ramster in 3.7) to become
the one-and-only in-tree drivers/staging/zcache (with ramster
as a subdirectory and build option)?  It would be nice to get
rid of that artificial and confusing distinction as soon as possible,
especially if, due to zswap, you have no plans to continue to
maintain/enhance/promote zcache1 anymore.

If so, I'll work with Konrad to generate a drivers/staging
patch for Greg (post-window :-).

Thanks,
Dan
