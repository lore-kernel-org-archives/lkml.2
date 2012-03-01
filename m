Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2CAUT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:19:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2CAUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:19:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Ott <alan@signal11.us>
Subject: Re: [PATCH 0/8] ARM: Tegra: cleanup patches from Arnd Bergmann
Date: Thu, 1 Mar 2012 20:19:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org
References: <1330630010-11241-1-git-send-email-alan@signal11.us>
In-Reply-To: <1330630010-11241-1-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012019.04316.arnd@arndb.de>
X-Provags-ID: V02:K0:T0cWNK7ZzTelI+DOKqMwdSv3Smb5uXdCDB5Q65YGac3
 1EbogxXTBBwKp2JlmOWZqPHwWZp6RM7WO/lpkuDXZhzrw/TgSr
 Cl1qsYHD7PjU6ZbchaKG8CCW7ylpDjVFGDOc3hciSyvuabnv3w
 byLqh9hQ9kWtTJmUsdFCRt2LoQ+JnZhQSwtoBUd7PVb+NF8Xe7
 cRQTjy2DEIF1+db8z+4B/shqkKJBQI0zN/ufANtlYe8oZPzNcJ
 zrr6Y8BH5k3kml592ZH+zGDL938ExbMfpcAjlUMlpRZ3Rw1EN5
 q/hqnyGoatHWjqWqv9aWWGkU9TgOChbnhWT8rPompl+IEQZXGu
 uGuVBEFnDyrDyZb5ZkTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Alan Ott wrote:
> I'm helping Arnd Bergmann get some of his cleanup patches upstream. This
> set covers the Tegra.
> 
> Thanks,
> 
> Alan.
> 
> Arnd Bergmann (8):
>   ARM: tegra: export tegra_gpio_{en,dis}able
>   ARM: tegra: do not hide dma declarations
>   ARM: tegra: select CPU_FREQ_TABLE
>   ARM: tegra: build localtimer support only when needed
>   ARM: tegra: work around tegra THUMB2_KERNEL bug
>   ARM: tegra: USB_ULPI needs USB
>   ARM: tegra: export usb phy symbols
>   ARM: tegra: HACK: remove set_irq_flags() from driver
> 

Hi Alan,

Thanks for getting this started!

As Greg already commented, there are some patches that you
should probably drop. When you send out a series with the
name of a subarchitecture, it's best to leave out the patches
that only address device drivers. I had initially sorted these
into the subarch series instead of the drivers series but that
turned out to be a bad idea. Sorry I didn't remember about this
detail when we first discussed the way forward on my patches.

Also, it's better if you have a slightly shorter Cc list and
for each patch take only the people on Cc that are actually
interested, rather than send the whole series to everyone
that get_maintainer.pl lists for one of the patches. If the
Cc list gets too long, that often means that the mails get
dropped from the mailing lists, and people might ignore them
when they don't understand why they were on Cc to start with.
It does help to have everyone on Cc for the initial mail though.

You can add 'Cc:' tags in the individual patches to help you
with that. This is another thing I never got around to for
the patches I did not send out.

Finally, when sending patches from someone else, you have
to add your own Signed-off-by: line below the others (i.e. mine).
Everyone who is handling the patch by sending it to someone
else should have a Signed-off-by in the email until the
point when it gets applied to a git tree that is pulled into
the Linus' tree.

	Arnd
