Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0HCKfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:43000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HCKfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="592392289"
Date: Tue, 3 Aug 2010 12:34:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH 2/2] tc6387xb: add __devinit/__devexit annotation for
 tc6387xb_probe/tc6387xb_remove
Message-ID: <20100803103410.GD2635@sortiz-mobl>
References: <1280814345.15753.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280814345.15753.4.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 01:45:45PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tc6387xb.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
Applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
