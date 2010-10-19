Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab0JSKT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:19:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:41353 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717Ab0JSKT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="565356963"
Date: Tue, 19 Oct 2010 12:19:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Todd Fischer <todd.fischer@ridgerun.com>
Subject: Re: [PATCH] mfd: tps6507x - fix off-by-one value range checking
Message-ID: <20101019101922.GI2736@sortiz-mobl>
References: <1286937879.453.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286937879.453.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Oct 13, 2010 at 10:44:39AM +0800, Axel Lin wrote:
> We use msg[0] for device register.
> If bytes == (TPS6507X_MAX_REGISTER + 1),
> we got a buffer overflow when doing memcpy(&msg[1], src, bytes);
> Thus we must ensure bytes not greater than TPS6507X_MAX_REGISTER.
Thanks, patch applied to my for-next tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
