Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3AJLNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:13:44 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40800 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3AJLNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMiTZvLJ6cXwMFsFc6pBGoLUEkV+WMrDOqqCcs_TEnTtUw@mail.gmail.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
	<CAOesGMiTZvLJ6cXwMFsFc6pBGoLUEkV+WMrDOqqCcs_TEnTtUw@mail.gmail.com>
Date: Thu, 10 Jan 2013 12:13:42 +0100
Message-ID: <CACRpkdZQAim4_3E6RG=d4pJi80B6W-xzW7n=Od86VJNcPO4FVw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add GPIO driver for Allwinner SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 4:35 PM, Olof Johansson <olof@lixom.net> wrote:

> I haven't looked closely at the patch yet, but this is a case where it
> makes sense to merge the gpio/pinctrl patch through Linus/Grant's
> tree, and merge the dtsi update through arm-soc -- while you need
> both, nothing is broken by having just one or the other, so taking the
> separate merge paths are fine.
>
> Linus, Grant, sound ok to you?

Sure. But I have requested a few changes to the patch set...

Linus Walleij
