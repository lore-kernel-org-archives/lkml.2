Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1GGL21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:28:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18018 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1GGL20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:28:26 -0400
Date: Thu, 7 Jul 2011 13:28:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: sdevrien@cisco.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3] Add support for the Philips SA56004 temperature sensor.
Message-ID: <20110707132817.65629f1b@endymion.delvare>
In-Reply-To: <20110626202648.GA9118@ericsson.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
	<20110626202648.GA9118@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun, 26 Jun 2011 13:26:48 -0700, Guenter Roeck wrote:
> On Mon, Jun 06, 2011 at 10:40:45AM -0000, sdevrien@cisco.com wrote:
> > From: Stijn Devriendt <sdevrien@cisco.com>
> > 
> > Add support for the Philips SA56004, an LM86
> > compatible temperature sensor.
> > 
> > Changes since v2:
> > - Changed BUG_ON to WARN_ON
> > Changes since v1:
> > - Updated documentation
> > - Trace replaced by BUG_ON
> > - style updates
> > 
> > Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>
> > Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > 
> I don't see a reason for holding this patch up further. Applied to -next.
> If you disagree, please speak up now or be silent forever.

Sorry for the long silence, I was frightened by the long discussion
back then - it's only today that I went through it to find most of it
was actually noise.

I don't have major objections to the patch, only a few things which I
think could be improved. So it's OK that your picked the patch as is,
I'll submit incremental patches for comments and review.

Stijn, please accept my apologies for being way less reactive than I
should have been, being the lm90 driver maintainer. And big thanks to
Guenter for backing me up.

-- 
Jean Delvare
