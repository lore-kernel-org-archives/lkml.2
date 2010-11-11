Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab0KKFKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 00:10:41 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:39452 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab0KKFKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 00:10:40 -0500
Date: Thu, 11 Nov 2010 07:10:18 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101111051017.GA16995@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <4CDAD255.3050309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDAD255.3050309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,

On Wed, Nov 10, 2010 at 09:11:49AM -0800, H. Peter Anvin wrote:
> On 11/03/2010 07:21 AM, Baruch Siach wrote:
> > From: Alex Gershgorin <agersh@rambler.ru>
> > 
> > The active serial protocol can be used to program Altera Cyclone FPGA devices.
> > This driver uses the kernel gpio interface to implement the active serial
> > protocol.
> 
> Calling it "Cyclone" is a bit misleading.  This protocol is used by
> Stratix, Cyclone and Arria devices (at least), and it probably depends
> more on the generation than on the product line which exact version of
> the protocol it is.
> 
> If anything it would probably be more accurate to call it a Statix
> protocol, or just an Altera one.

I see. I think I'll rename it to altera_as, for Altera active serial.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
