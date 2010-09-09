Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0IIU6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:58:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61280 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IIU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pk4rarUU5YJ9hKuXT2l8UcE/mBCyRx05k2DDkSTpDxovFWxzRpaZ8yEvInMIq+dfbL
         W/LOauXeZfP2CyJqfAfnBBSFhBbeKqQbDgx8z2BuTfruVPghOykhyDzqX6c7QszKfTRb
         5QGP1G2fNT7uBsK7wB7JeezVS/vgZ3eM1WT0U=
MIME-Version: 1.0
In-Reply-To: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
Date: Thu, 9 Sep 2010 22:58:38 +0200
Message-ID: <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/3 Masayuki Ohtake <masa-korg@dsn.okisemi.com>:

> Each instance of our SPI device has the same vendor ID and device ID.
> Thus, I think it is impossible to be called probe() for each instance.

Looking at you latest patch it appears you could :-)
That solves the problem pretty nicely.
If you incluse ChangeLogs it's easier to follow the development,
thanks.

Linus Walleij
