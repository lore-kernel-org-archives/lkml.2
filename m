Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2GPN5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:57:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:33783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2GPN52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123011758"
Date: Mon, 16 Jul 2012 15:57:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ
 mapping
Message-ID: <20120716135728.GK20652@sortiz-mobl>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
 <4FF6994B.9040801@linaro.org>
 <20120706173957.GA10202@core.coreip.homeip.net>
 <4FFB288D.4080606@linaro.org>
 <20120709201422.GA12242@core.coreip.homeip.net>
 <4FFB40A4.5060505@linaro.org>
 <20120709204620.GA12692@core.coreip.homeip.net>
 <4FFB463F.9040201@linaro.org>
 <20120710061757.GB29257@core.coreip.homeip.net>
 <5003C449.6000806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5003C449.6000806@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jul 16, 2012 at 08:35:37AM +0100, Lee Jones wrote:
> > I think it would be best if this got merged through whatever tree that
> > was used to introduce ab8500_irq_get_virq(); otherwise it will have to
> > wait till I resync with mainline sometime in the middle of the next
> > release cycle.
> 
> I agree. Sam that's you, patch below. :)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
