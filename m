Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0CVI4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:56:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:43733 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0CVI4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:56:40 -0400
Date: Mon, 22 Mar 2010 09:56:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2 2/6] hid: add framebuffer support to PicoLCD device
In-Reply-To: <20100321171128.324a606f@neptune.home>
Message-ID: <alpine.LNX.2.00.1003220955000.18642@pobox.suse.cz>
References: <20100320170014.440959a8@neptune.home> <20100320170415.6ee219c8@neptune.home> <45a44e481003210024l2c66938fp9436d34f6473f811@mail.gmail.com> <20100321171128.324a606f@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Bruno Prémont wrote:

> > > ---
> > >  drivers/hid/Kconfig       |    7 +-
> > >  drivers/hid/hid-picolcd.c |  454 +++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 460 insertions(+), 1 deletions(-)
> > 
> > It is customary for framebuffer drivers to live in drivers/video. This
> > is the first one I've reviewed that is outside of it. Is there a good
> > reason for this one to be outside of it? If so, could you put it in
> > the comments.
> 
> I've kept all the pieces of PicoLCD driver together under hid,
> as it's a HID based device. Framebuffer is just one of its features and
> keeping pieces together makes it easier to handle.

I think it makes sense for a HID driver for this device to contain the 
framebuffer bits as well ... from user perspective, this seems to be HID 
device, with "extra" framebuffer display on it.

If framebuffer folks Ack the fb-related code, I am fine keeping it under 
drivers/hid.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
