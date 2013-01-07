Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3AGUcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:32:25 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62371 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3AGUcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:32:24 -0500
Date: Mon, 7 Jan 2013 12:32:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Jenifer Hopper <jhopper@us.ibm.com>
Subject: Re: [PATCHv2 5/9] debugfs: add get/set for atomic types
Message-ID: <20130107203219.GA19596@kroah.com>
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-6-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357590280-31535-6-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:24:36PM -0600, Seth Jennings wrote:
> debugfs currently lack the ability to create attributes
> that set/get atomic_t values.

I hate to ask, but why would you ever want to do such a thing?

greg k-h
