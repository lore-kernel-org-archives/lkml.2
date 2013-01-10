Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3AJEPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 23:15:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:61294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab3AJEPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 23:15:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,441,1355126400"; 
   d="scan'208";a="272093859"
Date: Thu, 10 Jan 2013 12:14:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: lp8788-buck: Silence build warning
Message-ID: <20130110041457.GA13949@localhost>
References: <1357785186.28668.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357785186.28668.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the fix! It works!

Tested-by: Fengguang Wu <fengguang.wu@intel.com> 

