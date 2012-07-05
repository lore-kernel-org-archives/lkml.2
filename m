Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2GEPmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:42:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2GEPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:41:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device registration
Date: Thu, 5 Jul 2012 15:41:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, sameo@linux.intel.com
References: <20120703132447.GN29030@opensource.wolfsonmicro.com> <20120705141329.GN4111@opensource.wolfsonmicro.com> <4FF5A61F.2050400@linaro.org>
In-Reply-To: <4FF5A61F.2050400@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051541.52261.arnd@arndb.de>
X-Provags-ID: V02:K0:ZfTtEQj7+E6MhoEix4ywJaL1VNTBfc7yGr+zSapxKdO
 5I0LfFvg/h3yNixyAiA3Oimzna9YuWIUmxt6KluA58x50g8/wk
 uIJIbFOymLGRhaEOIQuUU5D+6jqkCgyiYL5ItEiUjBBOc3LhbS
 C+0DLsbygH59zyj/besKOH7CeIO3meHgyhQXZRO3hMlzODQJbv
 iV2t4+iWj0DYrAA6QezdbbBJYjwvbqChnjVssSXB+mcz6ohXJB
 +Au8H/1yF32WiV4xod21HCAcPzQwrpyCOdR3uQH9oJTcrvr3gy
 vbnHqlpRoiXP3y0vhP6UinqgLGCrzhaCmUEshvKxM9UNycVk3S
 A2HOSKAK1SNaPMg5I4DM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012, Lee Jones wrote:
> 
> On 05/07/12 15:13, Mark Brown wrote:
> > On Thu, Jul 05, 2012 at 03:06:20PM +0100, Lee Jones wrote:
> >> On 05/07/12 14:57, Arnd Bergmann wrote:
> >
> >>> The non-DT path for this is a huge mess, I'd rather focus on making
> >>> it obsolete than trying to fix it. Other than that, I agree that
> >>> we should be registering the ab8500 from the prcmu from both the
> >>> DT and the non-DT case.
> >
> >> Ah, is that what you were saying Mark?
> >
> >> If so, I apologise. I thought you meant register both from platform
> >> code. I'm happy to register the AB8500 from the DB8500 for both DT
> >> and !DT.
> >
> > Yes, that's what I was trying to say - sorry that I wasn't clear!
> 
> Well it seems silly of me just to copy Arnd's work. Do you want to 
> author and submit the patch to do this Arnd?

No, just assume ownership of it. I haven't tried building the
patch, so I assume you will have to change it some more. Just
list me as Suggested-by:.

	Arnd
