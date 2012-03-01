Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2CAT7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:59:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45867 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab2CAT7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:59:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.236.182.232 as permitted sender) smtp.mail=olof@lixom.net
MIME-Version: 1.0
X-Originating-IP: [172.22.162.26]
In-Reply-To: <1330630010-11241-2-git-send-email-alan@signal11.us>
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
	<1330630010-11241-2-git-send-email-alan@signal11.us>
Date: Thu, 1 Mar 2012 11:59:21 -0800
Message-ID: <CAOesGMhom2ybsKKgezPKkrhH9NniZu+FMprQhibHwEX92MNtEQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] ARM: tegra: export tegra_gpio_{en,dis}able
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 1, 2012 at 11:26 AM, Alan Ott <alan@signal11.us> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> These two functions are used in drivers that can be
> modules, so they need to be exported.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

With some of the pinmux changes going in this will no longer be
needed, but it is for now so:

Acked-by: Olof Johansson <olof@lixom.net>
