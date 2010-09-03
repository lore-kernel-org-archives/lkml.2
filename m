Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0ICR6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:58:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61049 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0ICR6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:58:01 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinpLeJzYjAh2bUngWD4ZvOyy44t9+4Zs9rm2=xQ@mail.gmail.com>
References: <4C80E2D5.1020104@dsn.okisemi.com> <AANLkTinYypWdty1eLH1LTyOEZPt-k=cEDGu_coyWVa2t@mail.gmail.com>
 <AANLkTinpLeJzYjAh2bUngWD4ZvOyy44t9+4Zs9rm2=xQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Sep 2010 11:57:40 -0600
X-Google-Sender-Auth: aBo_kcuVlw4kSeUxpZbzlEW6BXA
Message-ID: <AANLkTi==2=zX5A2L0=HFmWef_gXPmmVt1MHPGRS26wSw@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 11:50 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/9/3 Grant Likely <grant.likely@secretlab.ca>:
>> 2010/9/3 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
>>> SPI driver of Topcliff PCH
>
>> Instead, the majority of the code should be structured to handle one
>> and only one spi bus instance.  Only at the top level pci probe,
>> remove and PM code should there be for() loops for setting up or
>> tearing down each spi bus instance one at a time.
>
> I guess an elegant way to achieve this is to have the
> PCI driver spawn a simple platform device for each bus.
> Then you can even break the driver for that platform device
> into its own file and all.

Yes, that is exactly what I mean.

g.
