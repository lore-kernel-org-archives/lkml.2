Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2DZJKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:10:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61133 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DZJKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120426083504.GA3207@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
	<20120423101804.GA8318@opensource.wolfsonmicro.com>
	<4F953455.3080002@stericsson.com>
	<20120423110522.GB8318@opensource.wolfsonmicro.com>
	<4F95495D.4050508@stericsson.com>
	<4F954ED6.2040201@stericsson.com>
	<20120423180140.GR8318@opensource.wolfsonmicro.com>
	<CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
	<20120426083504.GA3207@opensource.wolfsonmicro.com>
Date: Thu, 26 Apr 2012 14:40:48 +0530
Message-ID: <CAJe_ZhdyqJVDvXCs_sw_SeB4Hfds+jRfj7JJp0VgG8j+XsXhZg@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during init
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2012 14:05, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Apr 25, 2012 at 09:04:01PM +0530, Jassi Brar wrote:
>
>>  Shouldn't the bootloader be responsible for ensuring MMC is
>> put down after using it and before passing control to the kernel.
>
> You might want to try to ensure that bootloaders always do the right
> thing but I prefer to work on more achievable goals like world peace. :/
>
>From what Ulf described so far, I am not sure if even gagging the regulator
api could be seen as a foolproof solution to the problem - he still doesn't
account for the necessary 'power-down sequence of commands' without
which the eMMC might fail attempts by the mmc stack to reset and initialize.

Appeasements and treaties could help achieve peace, I am just not sure
if former is a good option this time :)
