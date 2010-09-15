Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0IOL71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:59:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50504 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IOL70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dsDDvK9p4mtYAxO0G5foMY8Z6VepQyq8ZqAOLcb1w8SwUdaIE1xquoDJAaUT+pa8Ss
         tbw4hjTupEomatUnQ/t6BICcfJZKNQ/V2NK6U4juAbO5U5AVqHeCJokEwPCJ7RL6dib5
         P555tov/ul6htjVLgVz9PmZ/PpAmNf+7s8MK4=
MIME-Version: 1.0
In-Reply-To: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AE9@IL-MB01.marvell.com>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20100914190549.GA21918@void.printf.net>
	<20100915094006.GA21620@sirena.org.uk>
	<FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
	<20100915110001.GA4254@rakim.wolfsonmicro.main>
	<FCBE654890C0334289D0AD3AF4EF009FD18EE74AC7@IL-MB01.marvell.com>
	<AANLkTi=fsntfyAoFygrTrksVARvQpuxie6tFxCcuLtVR@mail.gmail.com>
	<FCBE654890C0334289D0AD3AF4EF009FD18EE74AE9@IL-MB01.marvell.com>
Date: Wed, 15 Sep 2010 19:59:24 +0800
Message-ID: <AANLkTimggn5WGyFS2SPkNPFzqKatvNd0OGwJ1CZ0S5-C@mail.gmail.com>
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC controller
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Saeed Bishara <saeed@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 6:29 PM, Saeed Bishara <saeed@marvell.com> wrote:
>
>
>>-----Original Message-----
>>From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
>>Sent: Wednesday, September 15, 2010 1:21 PM
>>To: Saeed Bishara
>>Cc: Mark Brown; Chris Ball; Andrew Morton;
>>linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
>>Subject: Re: [PATCH] mmc: Add architecture dependency for
>>Marvell SoC controller
>>
>>On Wed, Sep 15, 2010 at 6:06 PM, Saeed Bishara
>><saeed@marvell.com> wrote:
>>>
>>>>Which CPUs does the driver actually support?  The Kconfig and
>>>>commit log
>>>>just say "Marvell" so I went for the conservative option and included
>>>>all Marvell CPUs I was aware of.
>>> The Marvell Dove SoC includes this device, this SoC defined
>>by ARCH_DOVE
>>> I guess it found also only on mmp (defined by ARCH_MMP),
>>Haojian, can you confirm?
>>> saeed
>>
>>As I know, MG1 is also using this IP. Although MG1 isn't supported in
>>mainline, it's planned to be added into ARCH_PXA or one new ARCH. So
>>PLAT_PXA is preferred.
> I think (ARCH_DOVE || ARCH_MMP) is prefered, when MG1 gets added to mainline, then we will add that new ARCH.
>
> saeed

OK.
