Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2DYPeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:34:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34481 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab2DYPeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120423180140.GR8318@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
	<20120423101804.GA8318@opensource.wolfsonmicro.com>
	<4F953455.3080002@stericsson.com>
	<20120423110522.GB8318@opensource.wolfsonmicro.com>
	<4F95495D.4050508@stericsson.com>
	<4F954ED6.2040201@stericsson.com>
	<20120423180140.GR8318@opensource.wolfsonmicro.com>
Date: Wed, 25 Apr 2012 21:04:01 +0530
Message-ID: <CAJe_Zhd9gUJX05=q9Zjb5QX_SBtPYMBxDz5Gu+=H+GWt97Rf9w@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 23, 2012 at 02:45:10PM +0200, Ulf Hansson wrote:
>
>> If the platform already have booted from the eMMC card, the card is
>> already powered an initialized from a bootloader. Cutting the power
>> without first notifying the card by sending commands to it, must be
>> prevented and also violates the eMMC specification. In the end, it
>> will mean that the detect and initialization procedure fails.
>
 Shouldn't the bootloader be responsible for ensuring MMC is
put down after using it and before passing control to the kernel.

 Even if the bootloader didn't power off properly, unless there is
some outstanding data to be written when the kernel is passed
control, perhaps it's not that serious?
