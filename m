Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2BIBOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:14:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33499 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab2BIBOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:14:52 -0500
MIME-Version: 1.0
X-Originating-IP: [108.60.121.129]
In-Reply-To: <4F2BF512.4020602@atmel.com>
References: <4F2BF512.4020602@atmel.com>
Date: Wed, 8 Feb 2012 17:14:51 -0800
Message-ID: <CAOesGMjZWOEW5pNy_yJY-i6-oHu8Ehya-9+N=aofhRwtJ6Ubqg@mail.gmail.com>
Subject: Re: [GIT PULL] at91: at91sam9x5 family basic support
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 3, 2012 at 6:54 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Hi,
>
> Here is the pull request for inclusion of at91sam9x5 family basic support.
> I add the cover letter of the patch series that I sent some time ago:
>
> The at91sam9x5 family is an ARM926 based SoC family from Atmel.
> five different products are available: sam9g15, sam9g25, sam9g35 sam9x25 and sam9x35.
> Evaluation Kits are composed of a CPU Module and a carrier board (with optional screen).
> The use of the Device Tree is reducing the amount of code needed for an AT91 based SoC: sam9x5 are the first AT91 SoC that only rely on DT for their hardware configuration.
>
> This pull request goes on top of the at91-3.4-base branch.
>
> The following changes since commit 9918ceafd4a9e013572e03983f528017c29bb1cb:
>
>  ARM: at91: code removal of CAP9 SoC (2012-02-03 13:33:05 +0100)
>
> are available in the git repository at:
>  git://github.com/at91linux/linux-at91.git at91-3.4-base+9x5

Pulled, thanks.


-Olof
