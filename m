Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0HROi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:38:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:37694 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab0HROiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:38:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,227,1280732400"; 
   d="scan'208";a="648922830"
Date: Wed, 18 Aug 2010 22:38:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Webb <chris@arachsys.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Over-eager swapping
Message-ID: <20100818143801.GA9086@localhost>
References: <20100803033108.GA23117@arachsys.com>
 <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
 <20100803042835.GA17377@localhost>
 <20100803214945.GA2326@arachsys.com>
 <20100804022148.GA5922@localhost>
 <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com>
 <20100804032400.GA14141@localhost>
 <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost>
 <20100804120430.GB23551@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804120430.GB23551@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

Did you enable any NUMA policy? That could start swapping even if
there are lots of free pages in some nodes.

Are your free pages equally distributed over the nodes? Or limited to
some of the nodes? Try this command:

        grep MemFree /sys/devices/system/node/node*/meminfo

Thanks,
Fengguang
