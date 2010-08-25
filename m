Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0HYARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:17:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:15147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0HYARn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="831383449"
Date: Wed, 25 Aug 2010 08:17:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] hugetlb: fix metadata corruption in hugetlb_fault()
Message-ID: <20100825001731.GA10297@localhost>
References: <1282694127-14609-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1282694127-14609-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282694127-14609-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

