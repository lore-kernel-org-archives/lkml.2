Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1GIUrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:47:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:14824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GIUru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,505,1304319600"; 
   d="scan'208";a="28453331"
Date: Sat, 9 Jul 2011 13:47:49 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH 2/3] mm/readahead: Remove file_ra_state from arguments
 of count_history_pages.
Message-ID: <20110709204749.GB17463@localhost>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <a224acf18cff069f65e7e7eb10261e7dcfbb094f.1310239575.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a224acf18cff069f65e7e7eb10261e7dcfbb094f.1310239575.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 03:41:19AM +0800, Raghavendra D Prabhu wrote:
> count_history_pages doesn't require readahead state to calculate the offset from history.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thank you!
