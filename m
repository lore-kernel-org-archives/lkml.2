Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0KOPc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:32:58 -0500
Received: from darkstar.wilibox.com ([195.14.175.138]:41042 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0KOPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:32:57 -0500
Message-ID: <4CE152A5.9050408@gmail.com>
Date: Mon, 15 Nov 2010 17:32:53 +0200
From: Darius Augulis <augulis.darius@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [GIT PULL] Samsung fixes for 2.6.37-rc2
References: <007901cb84c2$7f465a30$7dd30e90$%kim@samsung.com>
In-Reply-To: <007901cb84c2$7f465a30$7dd30e90$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

you have missed "serial: samsung: fix device name" which is hanging here 
for a long time and was decided to merge in 2.6.37-rc1.
Please, pick it up.

thanks,
Darius


On 11/15/2010 02:41 PM, Kukjin Kim wrote:
> Hi Linus,
>
> Please pull Samsung fixes from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> These things are for fix build warnings on 2.6.37-rc2.
> If any problems, please let me know.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim<kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
> The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:
>
>    Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)
>
> are available in the git repository at:
>     git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> s5p-fixes-for-linus
>
> Kukjin Kim (2):
>        ARM: SAMSUNG: Fix HAVE_S3C2410_I2C warnings
>        ARM: SAMSUNG: Fix HAVE_S3C_RTC warnings
>
> Kyungmin Park (1):
>        ARM: SAMSUNG: Fix HAVE_S3C2410_WATCHDOG warnings
>
>   arch/arm/Kconfig              |   32 ++++++++++++++++----------------
>   arch/arm/mach-s3c64xx/Kconfig |    2 +-
>   2 files changed, 17 insertions(+), 17 deletions(-)
>

