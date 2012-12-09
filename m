Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab2LIPr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:47:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:37906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934222Ab2LIPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:47:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="261502944"
Date: Sun, 9 Dec 2012 16:47:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps6507x: Convert to devm_kzalloc
Message-ID: <20121209154721.GG26699@sortiz-mobl>
References: <1355055955.8506.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355055955.8506.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, Dec 09, 2012 at 08:25:55PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/tps6507x.c |   21 ++++-----------------
>  1 file changed, 4 insertions(+), 17 deletions(-)
Applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
