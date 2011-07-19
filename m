Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1GSKYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1GSKYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 06:24:21 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Amit Blay" <ablay@codeaurora.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Tue, 19 Jul 2011 12:26:58 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org> <201107191118.48536.oneukum@suse.de> <072dac57b14fc739033c65fe289234c3.squirrel@www.codeaurora.org>
In-Reply-To: <072dac57b14fc739033c65fe289234c3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107191226.58593.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Juli 2011, 12:07:39 schrieben Sie:

Hi,

> >> 1. Interface number [IN]
> >> 2. Bitmap indicating which EP to allocate streams for [IN]
> >
> > If this is a bitmap,
> >
> >> 3. Number of streams to allocate, one number [IN}
> >> 4. Number of streams actually allocated, one number  [OUT]
> >
> > how can those be scalars?
> >
> 
> The bitmap only indicates which EP the user space requests to allocate
> streams for. The actual number is taken from #3.

Exactly. If you specify EP with a bitmap, what do you do if multiple bits
are set in the map?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
