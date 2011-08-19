Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1HSQ1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:27:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab1HSQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:27:46 -0400
Date: Fri, 19 Aug 2011 20:27:41 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-dev@lists.linaro.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch v2 04/11]Power: DA9052 battery driver
Message-ID: <20110819162741.GC22761@oksana.dev.rtsoft.ru>
References: <1311339141.1796.42.camel@L-0532.kpit.com>
 <1312462072.2388.1.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312462072.2388.1.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 06:17:52PM +0530, ashishj3 wrote:
> On Fri, 2011-07-22 at 18:22 +0530, ashishj3 wrote: 
> > Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
> > for definitions and methods.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> > Changes since v2
> > - Correct code styling for inline functions
> > - Remove averaging algorithm
> > - Set use_for_apm thru board specific parameter
> > ---
> Any comments on this patch?

Despite some cosmetic issues, the patch looks OK to me.

So, I'm fine if it goes via MFD tree.

Although, if you ever need to respin this patch, try to make the
code fully conform to the Linux coding style.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
