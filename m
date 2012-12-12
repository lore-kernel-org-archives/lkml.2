Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2LLQbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:31:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58311 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2LLQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:31:15 -0500
Message-ID: <50C8B0EA.6040205@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 10:29:30 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/8] zswap: compressed swap caching
References: <1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com> <20121211220148.GA12821@kroah.com>
In-Reply-To: <20121211220148.GA12821@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121216-7606-0000-0000-000006628930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 04:01 PM, Greg Kroah-Hartman wrote:
> On Tue, Dec 11, 2012 at 03:55:58PM -0600, Seth Jennings wrote:
>> Zswap Overview:
> 
> <snip>
> 
> Why are you sending this right at the start of the merge window, when
> all of the people who need to review it are swamped with other work?

Yes, sorry, poor timing :-/

I'm just looking for early feedback from those that are not swamped
doing merge window stuff.

Thanks,
Seth

