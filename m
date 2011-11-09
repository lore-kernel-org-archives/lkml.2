Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab1KIW7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:59:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60972 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab1KIW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:59:37 -0500
Date: Wed, 9 Nov 2011 22:59:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109225933.GA17769@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
 <20111109164211.GA4016@opensource.wolfsonmicro.com>
 <20111109165518.GA13451@kroah.com>
 <20111109165829.GC4016@opensource.wolfsonmicro.com>
 <20111109173037.66bea268@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109173037.66bea268@lxorguk.ukuu.org.uk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 05:30:37PM +0000, Alan Cox wrote:

> Something like this I think

Yes, though...

> --- a/sound/soc/codecs/sn95031.c
> +++ b/sound/soc/codecs/sn95031.c
> @@ -39,7 +39,7 @@
>  #include <sound/initval.h>
>  #include <sound/tlv.h>
>  #include <sound/jack.h>
> -#include "../../../drivers/staging/intel_sst/intel_sst.h"
> +#include "../mid-x86/intel_sst.h"

..this can hopefully just be removed completely, if it's needed that
seems wrong.
