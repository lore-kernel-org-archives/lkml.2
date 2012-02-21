Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2BULFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:05:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:23176 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2BULFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:05:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108902956"
Date: Tue, 21 Feb 2012 12:05:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] MFD: twl6040: Conversion to i2c driver
Message-ID: <20120221110533.GT5387@sortiz-mobl>
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com>
 <20120220194736.GN5387@sortiz-mobl>
 <4F4372E3.4050408@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4372E3.4050408@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Feb 21, 2012 at 12:33:07PM +0200, Peter Ujfalusi wrote:
> > I'm not sure hwo we could handle that properly. Either by letting Tony
> > carrying this patchset, or by sending me the panda patch that adds those
> > structures. As you prefer.
> 
> If Liam would take this series that would be probably the way forward.
> If he does not have objections.
> Liam: I can create a branch for you to pull from as soon as all other
> patch receives the needed acks...
> 
> Samuel: if Liam agrees is it possible for you to drop the twl6040
> related patches from your for-next branch?
That would make sense to me, yes.
Liam, if you're ok with taking it, please add my:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to this patchset.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
