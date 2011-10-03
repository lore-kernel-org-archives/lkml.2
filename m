Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1JCPuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:50:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:63114 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab1JCPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,480,1312182000"; 
   d="scan'208";a="69804314"
Date: Mon, 3 Oct 2011 17:53:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 13/23] mfd/db5500-prcmu: update mailbox handling
Message-ID: <20111003155331.GR4118@sortiz-mobl>
References: <1313137760-31015-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137760-31015-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 12, 2011 at 10:29:20AM +0200, Linus Walleij wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> This updates the mailbox handling to be more robust and
> adds basic infrastructure for event (IRQ) handling.
This patch and the next one (#14) adds 500 lines of code but I have the
feeling a lot of it could be shared between 8500 and 5500. What are your plans
for that ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
