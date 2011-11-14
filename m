Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1KNAPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:15:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:51685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab1KNAPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:15:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,503,1315206000"; 
   d="scan'208";a="74335477"
Date: Mon, 14 Nov 2011 01:19:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/2] mfd: include linux/module.h for ab5500-core
Message-ID: <20111114001925.GF22218@sortiz-mobl>
References: <1320635954.10415.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320635954.10415.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Nov 07, 2011 at 11:19:14AM +0800, Axel Lin wrote:
> Include linux/module.h to fix below build error:
Both patches applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
