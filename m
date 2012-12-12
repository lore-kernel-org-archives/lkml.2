Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2LLSdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:33:05 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40970 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab2LLSdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:33:03 -0500
Message-ID: <50C8CDD7.8040302@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 12:32:55 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/8] zswap: compressed swap caching
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com> <20121211220148.GA12821@kroah.com> <50C8B0EA.6040205@linux.vnet.ibm.com> <59a1d7ee-e5dc-4923-8544-605c35c632af@default>
In-Reply-To: <59a1d7ee-e5dc-4923-8544-605c35c632af@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121218-7182-0000-0000-000003BD3150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:27 AM, Dan Magenheimer wrote:
> Related, are you now comfortable with abandoning "zcache1" and
> moving "zcache2" (now in drivers/staging/ramster in 3.7) to become
> the one-and-only in-tree drivers/staging/zcache (with ramster
> as a subdirectory and build option)?  It would be nice to get
> rid of that artificial and confusing distinction as soon as possible,
> especially if, due to zswap, you have no plans to continue to
> maintain/enhance/promote zcache1 anymore.

Yes, that's fine by me.  I guess that didn't get said explicitly in
the last discussion so sorry for any confusion.

Seth

