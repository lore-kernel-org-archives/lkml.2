Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2BFPhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:37:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:54273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab2BFPhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:37:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103801540"
Date: Mon, 6 Feb 2012 23:25:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, xiyou.wangcong@gmail.com,
        penberg@kernel.org, cl@linux.com
Subject: Re: [PATCH 1/3] move page-types.c from Documentation to tools/vm
Message-ID: <20120206152500.GA5687@localhost>
References: <20120205081542.GA2245@darkstar.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205081542.GA2245@darkstar.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 04:15:42PM +0800, Dave Young wrote:
> tools/ is the better place for vm tools which are used by many people.
> Moving them to tools also make them open to more users instead of hide in
> Documentation folder.
> 
> This patch move page-types.c to tools/vm/page-types.c
> Also add Makefile in tools/vm and fix two coding style problems of below:
> a. change const arrary to 'const char * const'
> b. change a space to tab for indent
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
