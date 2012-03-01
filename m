Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2CAUMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:12:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab2CAUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:12:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Date: Thu, 1 Mar 2012 20:12:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-9-git-send-email-alan@signal11.us> <20120301193643.GA607@kroah.com>
In-Reply-To: <20120301193643.GA607@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012012.01266.arnd@arndb.de>
X-Provags-ID: V02:K0:7D7jwbXhmJODHQsC6VjmzpYpbduPW2NskNOaKuZzrbz
 R1o4rMJYRyVs7YOjAVHiV84+LGrtnKHjlZabY20nZubmauWwmp
 W3SUD14TiZ8MUwZVGZDFd0mYkaOHEUMWvMogzVaaFHr6EOKfNK
 9l772ebhBKaJcLbHSl9Uby/74DRSZrXJvqph5c/f4EkMCMpm3f
 CG59X9bYpHri4AO0d0pYan6W15bYgpEBZpdov2+j6VVscEtsx0
 Jc0yBn+TxQ9quWcaSBlZ7gudHwxjtTSyrq/Olq36n3DRU8R0q4
 t2zwtWFKVFbd7ePEzRMhBBdbinq/w5Vs76/Pg/tU+i7kqCnlOe
 R3FlIs/EF7cDyhe4nMnk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Greg Kroah-Hartman wrote:
> On Thu, Mar 01, 2012 at 02:26:50PM -0500, Alan Ott wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The driver should not call set_irq_flags itself, and
> > cannot do this from a loadable module.
> > 
> > Remove the call for now, which might break the driver
> > but at least lets the kernel link again.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Um, I think you should test this out before submitting it anywhere :)
> 
> As it is, I can't accept it.

Right, this one was not meant for inclusion, similar to patch 5 in this
series.

Alan:
Part of the reason I asked for help getting the patches out is that
they need a lot of auditing, both for whether they still apply to
current kernels and for whether they are a good solution to the problem
at hand. When in doubt, it's probably better to leave out any patch
that looks like it might not be ready for inclusion, or that might
make thinks uglier in some way.

	Arnd
