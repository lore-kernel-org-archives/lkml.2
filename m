Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2IROoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:44:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57010 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab2IROoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:44:22 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:24c8:79b5:efe7:d61c]
In-Reply-To: <5058313F.8060704@atmel.com>
References: <5058313F.8060704@atmel.com>
Date: Tue, 18 Sep 2012 07:44:21 -0700
Message-ID: <CAOesGMgSqmvtOeANaAHW_XVt=YaUGe2xmL6FMd_X-9=fArC_0g@mail.gmail.com>
Subject: Re: [GIT PULL] at91: one fix for 3.6
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        voice <voice.shen@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:30 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof,
>
> We have one last minute fix. It can help us to use the device tree for
> GPIO interrupt attached devices. I have based my tag on top of the "fixes" pull
> request that I've already sent to you.
> I hope that it could make it for 3.6-final.
>
> The following changes since commit 51a6149b89b822cacf572b2ca2a15cb6f2232b11:
>
>   ARM: at91/feature-removal-schedule: delay at91_mci removal (2012-08-27 09:59:36 +0200)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes

Pulled, thanks.


-Olof
