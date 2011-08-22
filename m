Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1HVOCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:02:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:32947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab1HVOCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:02:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40963373"
Date: Mon, 22 Aug 2011 16:04:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mfd: tps65910: fix initialisation of interrupts
Message-ID: <20110822140437.GT4607@sortiz-mobl>
References: <1313404923-2502-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313404923-2502-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan

On Mon, Aug 15, 2011 at 12:42:03PM +0200, Johan Hovold wrote:
> Fix regression introduced by commit
> a2974732ca7614aaf0baf9d6dd3ad893d50ce1c5 (TPS65911: Add new irq
> definitions) which caused irq_num to be incorrectly set for tps65910.
Patch applied to bot my for-next and for-linus branches, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
