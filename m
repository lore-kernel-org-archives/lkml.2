Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0JWNrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 09:47:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49397 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0JWNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 09:47:19 -0400
Subject: Re: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20101022153006.GB16521@opensource.wolfsonmicro.com>
References: <1287736702.2996.4.camel@mola>
	 <20101022153006.GB16521@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Oct 2010 14:47:15 +0100
Message-ID: <1287841635.7486.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 08:30 -0700, Mark Brown wrote:
> On Fri, Oct 22, 2010 at 04:38:22PM +0800, Axel Lin wrote:
> > The Singular Message is 16 bits:
> >         DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]
> > 
> > Current implementation return immedially after sucessfuly write MSB part.
> > To properly set mode, we need to write the complete message ( MSB and LSB ).
> > 
> > In twl.h, now we have defines for PM Master module register offsets,
> > use it instead of hard coded 0x15/0x16.
> > 
> > Use "message & 0xff" to ensure we send correct value for LSB.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> > I don't have this hardware handy, I appreciate if someone who has the
> > hardware can test this patch.
> 
> I beleive Liam has appropriate hardware.

Rejendra, care to test this ?

Thanks

Liam 
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

