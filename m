Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2DNJr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:47:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:46459 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2DNJr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:47:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141658478"
Date: Sat, 14 Apr 2012 17:42:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: page-writeback.c: local functions should not be
 exposed globally
Message-ID: <20120414094222.GA19710@localhost>
References: <201204121344.20613.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204121344.20613.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 01:44:20PM -0700, H Hartley Sweeten wrote:
> The function global_dirtyable_memory is only referenced in this file and
> should be marked static to prevent it from being exposed globally.
> 
> This quiets the sparse warning:
> 
> warning: symbol 'global_dirtyable_memory' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied, thanks!

Fengguang
