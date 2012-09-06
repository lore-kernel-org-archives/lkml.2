Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2IFWc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:32:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38816 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2IFWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <201208181808.21484.arnd@arndb.de>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
	<201208181808.21484.arnd@arndb.de>
Date: Thu, 6 Sep 2012 19:25:51 -0300
Message-ID: <CAOMZO5C2ihKUeQk17JOHc9VXAB3KTeQLS3OcLOiiUC8jucsexg@mail.gmail.com>
Subject: Re: [PATCH 01/11] ARM: defconfig: Remove CONFIG_MISC_DEVICES
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Sat, Aug 18, 2012 at 3:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 18 August 2012, Fabio Estevam wrote:
>>
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed
>> CONFIG_MISC_DEVICES option, so remove the occurrences from the config files
>> as well.
>>
>> Cc: <linux-arm-kernel@lists.infradead.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I am not sure who would pick up this series.

Is it possible for you to apply these patches?

Thanks,

Fabio Estevam
