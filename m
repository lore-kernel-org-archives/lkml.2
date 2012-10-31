Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2JaHWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:22:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60200 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab2JaHWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:22:45 -0400
MIME-Version: 1.0
In-Reply-To: <20121030210213.GA6098@kroah.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
	<1351530381-11459-2-git-send-email-omar.luna@linaro.org>
	<20121029175228.GD11908@atomide.com>
	<CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
	<20121030162441.GF11908@atomide.com>
	<20121030210213.GA6098@kroah.com>
Date: Wed, 31 Oct 2012 02:22:44 -0500
Message-ID: <CALLhW=6p06MPdfbD2S-PRs=w0zLNsEifsJ2xL0hjEZaFpbadDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap headers
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Juan Gutierrez <jgutierrez@ti.com>, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Suman Anna <s-anna@ti.com>, linux-arm-kernel@lists.infradead.org,
        Loic PALLARDY <loic.pallardy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 30 October 2012 16:02, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> OK.
>>
>> Greg, do these patches look OK to you to move to live under
>> drivers/mailbox?
>
> Um, I don't know, I wasn't paying attention here, sorry.

As part of plat-omap code cleanup, I was planning to move omap-mailbox
framework to a newly drivers/mailbox folder, right now this code is
specific to OMAP platforms, but with some clean up it could be the
base for a generic framework. And living under drivers/mailbox could
give it some exposure for interested developers to give feedback and
propose changes.

In the past there was a mailbox-like driver in mach-ux500, I was
hoping both could live under the same folder, however the platform
using it, was dropped a couple of kernel releases back and with it the
other similar mailbox implementation.

So, here it is the thread with the patches:
http://thread.gmane.org/gmane.linux.kernel/1384603, if you think it is
OK for them to be moved under drivers/mailbox, I just need to re-spin
them to move the mailbox header file to include/linux/mailbox instead
of include/linux/platform_data.

Cheers,

Omar
