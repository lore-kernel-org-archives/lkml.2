Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0HCKdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:33:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:4360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HCKdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="541445107"
Date: Tue, 3 Aug 2010 12:33:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH 1/2] tc6387xb: fix resource reclaim
Message-ID: <20100803103341.GC2635@sortiz-mobl>
References: <1280814240.15753.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280814240.15753.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 01:44:00PM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. add a missing iounmap in tc6387xb_probe() error path
> 2. fix resource reclaim in tc6387xb_remove()
Patch applied, thanks.

Cheers,
Samuel.
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
