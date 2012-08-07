Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2HGQfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:35:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46688 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2HGQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:35:21 -0400
Date: Tue, 7 Aug 2012 17:34:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: balbi@ti.com, Peiyong Feng <peiyong.feng.kernel@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Kernel panic when try s3c-hsotg.c with kernel 3.5
Message-ID: <20120807163455.GB14711@sirena.org.uk>
References: <CAN_1RdsTX5ZGSx7T6X0t70Q6k5_M1zgizL-KzPYrnHOnZ_nfSg@mail.gmail.com>
 <20120806101200.GJ17551@arwen.pp.htv.fi>
 <20120806151436.4761cd4d@amdc308.digital.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806151436.4761cd4d@amdc308.digital.local>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:14:36PM +0200, Lukasz Majewski wrote:
> > On Mon, Aug 06, 2012 at 06:12:05PM +0800, Peiyong Feng wrote:
> > > I got a kernel panic when try hsotg of ok6410 which is based on
> > > s3c6410:

> As you said, you are using the ok6410. And it is "based" on the s3c6410
> CPU. S3C6410 is a single core CPU. I assume that ok6410 is also single
> core?

FWIW I think what the above means is "I am using the ok6410 board which
has a s3c6410 SoC on it".
