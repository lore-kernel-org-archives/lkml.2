Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2CDTA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:00:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59027 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2CDTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:00:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.101.114.14 as permitted sender) smtp.mail=olof@lixom.net
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120304183513.GA31064@quad.lixom.net>
References: <1330721903-8571-1-git-send-email-alan@signal11.us>
	<20120304183513.GA31064@quad.lixom.net>
Date: Sun, 4 Mar 2012 11:00:26 -0800
Message-ID: <CAOesGMg4nBjUGb_KzZk1_d2FvCmbW2kwFqh9q_9S8TQqgYO8hw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: tegra: do not hide dma declarations
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 10:35 AM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Mar 02, 2012 at 03:58:23PM -0500, Alan Ott wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The declarations are actually required for the device
>> definitions, and are still valid even if the dma controller
>> is disabled:
>>
>> arch/arm/mach-tegra/devices.c:559:12: error: 'TEGRA_DMA_REQ_SEL_I2S_1' undeclared here (not in a function)
>> arch/arm/mach-tegra/devices.c:577:12: error: 'TEGRA_DMA_REQ_SEL_I2S2_1' undeclared here (not in a function)
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Alan Ott <alan@signal11.us>
>
> Thanks, applied to cleanups-and-fixes for 3.4.

Oh, a corresponding fix for this is already in mainline, so I dropped
it again (noticed due to conflicts).


-Olof
