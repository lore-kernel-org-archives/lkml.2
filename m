Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2HVX3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:29:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab2HVX3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:29:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH 1/17] input: RMI4 public header file and documentation.
Date: Thu, 23 Aug 2012 01:35:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Christopher Heiny <cheiny@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-2-git-send-email-cheiny@synaptics.com> <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com>
In-Reply-To: <CACRpkdbP1uTXC9jVNVG3es0KFRq+8MaUa6=6nPuG5WUz5jgiRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208230135.55087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 22, 2012, Linus Walleij wrote:
> On Sat, Aug 18, 2012 at 12:17 AM, Christopher Heiny
> <cheiny@synaptics.com> wrote:
> 
> (...)
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +#include <linux/earlysuspend.h>
> > +#endif
> 
> This does not exist in the mainline kernel, I can see you're having fun with
> Android ... check with Rafael on how to really handle this in a contemporary
> kernel.

You can't.  Early suspend is not going to be merged.

Thanks,
Rafael
