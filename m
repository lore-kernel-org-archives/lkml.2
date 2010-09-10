Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0IJCFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:05:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46777 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab0IJCFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:05:12 -0400
Date: Thu, 9 Sep 2010 20:05:09 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Message-ID: <20100910020509.GA7592@angua.secretlab.ca>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
 <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
 <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 09:27:05AM +0900, Masayuki Ohtake wrote:
> Hi Linus,
> 
> Thank you for your checking.
> 
> > If you incluse ChangeLogs it's easier to follow the development,
> > thanks.
> 
> The latest patch has included the following Changelog.
> 
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> > devices connected to SPI.
> 
> Do you mean the above our Changelog is lack of something ?

Linus just means that when you update and repost patches, it is
customary to place a version number in the subject header (ie: "[PATCH
v3]") and make a note in the change log about what has changed from
the previous version.

Something like this:

http://patchwork.ozlabs.org/patch/63703/

g.
