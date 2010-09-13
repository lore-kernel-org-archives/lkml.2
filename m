Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0IMPtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:49:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:47486 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0IMPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:49:31 -0400
Date: Mon, 13 Sep 2010 08:29:05 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        david Brownell <dbrownell@users.sourceforge.net>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        LKML <linux-kernel@vger.kernel.org>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
Message-ID: <20100913152905.GB24329@suse.de>
References: <4C85EE6F.6000706@dsn.okisemi.com>
 <20100908002229.GC15785@suse.de>
 <000b01cb52fb$794d2940$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000b01cb52fb$794d2940$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:23:40PM +0900, Masayuki Ohtake wrote:
> Hi Greg
> 
> > > +#define PCH_UDC_BIT_CLR(reg, bitMask) \
> > > + iowrite32((ioread32((reg)) & (~(bitMask))), (reg))
> >
> >
> > Why not just use the iowrite32 functions directly?  Or surely there's
> > another built-in kernel macro for this somewhere, right?
> 
> [masa]
> Which macro is it?
> Do you know?

Nope, sorry, try digging around.

good luck,

greg k-h
