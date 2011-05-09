Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1EIMcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:32:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42951 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752352Ab1EIMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:32:12 -0400
Date: Mon, 9 May 2011 14:32:18 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Message-ID: <20110509123218.GC3225@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8D9@KCINPUNHJCMS01.kpit.com>
 <20110504135833.c44c372d.akpm@linux-foundation.org>
 <20110505140238.GB26651@sirena.org.uk>
 <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713D4@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713D4@KCINPUNHJCMS01.kpit.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:02:18PM +0530, Ashish Jangam wrote:

> > Ideally you should do this by submitting all your patches in a single
> > patch series.

> LED module is dependent upon MFD module so does this mean that along
> with the LED patch we also need to give MFD patch as reference or just
> list down the dependent module in the LED patch. 

Look at how other people submit similar drivers: submit a single patch
series with everything in it and CC the relevant people on the relevant
bits.
