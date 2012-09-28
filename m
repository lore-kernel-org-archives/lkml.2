Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2I1MfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:35:09 -0400
Received: from antcom.de ([188.40.178.216]:37103 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810Ab2I1MfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:35:06 -0400
Message-ID: <50659978.8010003@antcom.de>
Date: Fri, 28 Sep 2012 14:35:04 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, Bill Gatliff <bgat@billgatliff.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
References: <1348780923-27428-1-git-send-email-stigge@antcom.de> <CACRpkdZ+1ffsMDRZXYb5RRndoXstj_QHvHOpeikRY0bas72dKQ@mail.gmail.com> <50657356.4010801@antcom.de> <CACRpkdbEgBqSdZmebw+PBMo9G_Y24mgz17=dp11VrbKf5fKyDQ@mail.gmail.com>
In-Reply-To: <CACRpkdbEgBqSdZmebw+PBMo9G_Y24mgz17=dp11VrbKf5fKyDQ@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/28/2012 01:34 PM, Linus Walleij wrote:
>> Or some kind of new character device node?
> 
> Yes, I don't know if we should create /dev/gpioN or /dev/pinctrlN for
> this, and add GPIO functions to pinctrl (while wrapping it in the
> gpiolib to aid migration) the latter would encourage users of the
> new ABI to switch to writing pinctrl drivers.

Will have a look at this.

>> Otherwise, I need to think about leaving out the sysfs for this purpose.
> 
> Do you really need it?

In more that half of the cases, I needed userspace access. So I'm quite
interested in it.

Thanks for your notes.

Roland
