Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0IJBae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:30:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1593 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0IJBad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:30:33 -0400
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
From: Joe Perches <joe@perches.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
	 <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
	 <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 18:30:29 -0700
Message-ID: <1284082229.24986.253.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 09:27 +0900, Masayuki Ohtake wrote:
> > If you incluse ChangeLogs it's easier to follow the development,
> > thanks.
> The latest patch has included the following Changelog.

I believe Linus is asking for the same thing as I did.

Some means to track your the changes in your multiple submissions
of the same files.

Typically, this would be a git repository where people can
read the delta patches instead of entire unversioned files.

cheers, Joe

