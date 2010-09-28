Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0I1FaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 01:30:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43081 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0I1FaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 01:30:06 -0400
Date: Tue, 28 Sep 2010 06:29:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Alek Du <alek.du@intel.com>,
        richard.rojfors@mocean-labs.com, meego-dev@meego.com,
        ML linux-kernel <linux-kernel@vger.kernel.org>, Qi <qi.wang@intel.com>,
        andrew.chih.howe.khor@intel.com, gregkh@suse.de,
        Yong Y <yong.y.wang@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>, joel.clark@intel.com,
        margie.foster@intel.com, kok.howg.ewe@intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-ID: <20100928052950.GB5878@sirena.org.uk>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org> <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com> <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com> <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com>
X-Cookie: Remember the... the... uhh.....
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 02:25:36PM +0900, Masayuki Ohtake wrote:

> > find out what range of GPIO numbers your driver is using and use those
> > instead of "1"
> I have attached a part of our source file.

> Since I set "ngpio=12",
> I guess 0-11 can be used, thus, "echo 1 > export" should be success too.
> Is this true ?

> begin 666 pch_gpio.c
> M<W1A=&EC('9O:60@<&-H7V=P:6]?<V5T=7 H<W1R=6-T('!C:%]G<&EO7V-H
> M:7 @*F-H:7 I#0I[#0H)<W1R=6-T(&=P:6]?8VAI<" J9W!I;R ]("9C:&EP

Your mail client has for some reason chosen to uuencode the attachment
so it's going to be difficult for most people to read it.  If you have
debugfs enabled and mounted you can see the current GPIO banks in the
file 'gpio' under debugfs.
