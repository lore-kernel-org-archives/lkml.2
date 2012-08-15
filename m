Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2HOCgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 22:36:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:50280 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2HOCga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 22:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="201195831"
Date: Wed, 15 Aug 2012 10:36:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Salter <msalter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
Message-ID: <20120815023608.GA24697@localhost>
References: <20120814153413.GA18601@localhost>
 <1344961371.30830.43.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344961371.30830.43.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define L1_CACHE_BYTES        L2_CACHE_BYTES
> +#define L1_CACHE_SHIFT        L2_CACHE_SHIFT
> +#define L1_CACHE_BYTES        (1 << L2_CACHE_SHIFT)

Nitpick: the last line could better be:

+#define L1_CACHE_BYTES        (1 << L1_CACHE_SHIFT)

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!
