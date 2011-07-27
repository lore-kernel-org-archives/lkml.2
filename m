Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1G0Jwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:52:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:57075 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1G0Jws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="31992554"
Date: Wed, 27 Jul 2011 11:53:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Hemanth V <hemanthv@ti.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd: twl6030-pwm.c needs MODULE_LICENSE
Message-ID: <20110727095357.GE26275@sortiz-mobl>
References: <20110722171708.370b2cf5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722171708.370b2cf5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Fri, Jul 22, 2011 at 05:17:08PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> twl6030_pwm: module license 'unspecified' taints kernel.
Thanks, I applied this patch (with Felipe's ACK).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
