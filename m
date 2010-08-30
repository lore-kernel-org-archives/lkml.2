Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0H3NdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:33:15 -0400
Received: from hanwang.com.cn ([221.122.51.51]:58682 "EHLO mail.hanwang.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0H3NdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:33:13 -0400
Date: Mon, 30 Aug 2010 21:33:12 +0800
From: "Xing Wei" <weixing@hanwang.com.cn>
To: "jkosina" <jkosina@suse.cz>
Cc: "linux-input" <linux-input@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] input: Add support for Hanwang tablet
Message-ID: <201008302133119064558@hanwang.com.cn>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Jiri Kosina Wrote: 
> > On Mon, 30 Aug 2010, Xing Wei wrote:
> >  
> > +config TABLET_USB_HANWANG
> > +	tristate "Hanwang Art Master III tablet support (USB)"
> > +	depends on USB_ARCH_HAS_HCD
> > +	select USB
> > +	help
> > +	  Say Y here if you want to use the USB version of the Hanwang Art
> > +	  Master III tablet.  Make sure to say Y to "Mouse support"
> > +	  (CONFIG_INPUT_MOUSEDEV) and/or "Event interface support"
> > +	  (CONFIG_INPUT_EVDEV) as well.
> 
> Is there any reason why you don't have these (MOUSEDEV and EVDEV) as 
> explicit Kconfig dependencies?
> 
> Thanks,
> 

I just reference the other USB tablet on this Kconfig,like aiptek,acecad,wacom.
Actually it depends on EVDEV at least now.
I can submit another patch if necessarry.

Thanks Jiri. 

