Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab1HXJdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:33:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:12965 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1HXJdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,274,1312182000"; 
   d="scan'208";a="41839857"
Date: Wed, 24 Aug 2011 17:33:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: slow performance on disk/network i/o full speed after
 drop_caches
Message-ID: <20110824093336.GB5214@localhost>
References: <4E5494D4.1050605@profihost.ag>
 <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
 <4E54BDCF.9020504@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E54BDCF.9020504@profihost.ag>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 05:01:03PM +0800, Stefan Priebe - Profihost AG wrote:
> 
> >> sync&&  echo 3>/proc/sys/vm/drop_caches&&  sleep 2&&  echo 0
> >>> /proc/sys/vm/drop_caches
> 
> Another way to get it working again is to stop some processes. Could be 
> mysql or apache or php fcgi doesn't matter. Just free some memory. 
> Although there are already 5GB free.

Is it a NUMA machine and _every_ node has enough free pages?

        grep . /sys/devices/system/node/node*/vmstat

Thanks,
Fengguang

