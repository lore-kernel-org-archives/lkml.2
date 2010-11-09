Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0KIIHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:07:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34000 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab0KIIHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G5Jb6r7pgBISVne3/Y4R9vldLeED53pPCrZlIJRaUEuSlg/Ksmrq0dbiRCXAA9Ybfy
         amkiMkO2F/a1T9Vwfy+ttfGRhPhpSlTBPlTA7auXo8K80LfOFVdBWdKKwN9hqUkp7Iax
         OOivk8y2nnsSLWWMe2ULpBqtt/tGaoquMJbiY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=YjrnD6owL-xv41XYaDFwy+K9SyymnoNuKhAzN@mail.gmail.com>
References: <4CD51A9B.7010806@gmail.com>
	<20101108091302.GO16938@pengutronix.de>
	<AANLkTinmQtrLJcjxRSwbHARrgE-4FEaJeDt4R8C2tLHY@mail.gmail.com>
	<AANLkTi=YjrnD6owL-xv41XYaDFwy+K9SyymnoNuKhAzN@mail.gmail.com>
Date: Tue, 9 Nov 2010 09:07:03 +0100
Message-ID: <AANLkTim8++gbgfnUpEM=cbdRcLxttEhqccHC5_COz-LK@mail.gmail.com>
Subject: Re: [PATCH] arm: fix compilation warning during compilation
From: Marco Stornelli <marco.stornelli@gmail.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Sanjeev Premi <premi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Gadiyar, Anand <gadiyar@ti.com>:
> 2010/11/8 Marco Stornelli <marco.stornelli@gmail.com>:
>> 2010/11/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>>> Hello,
>>>
>>> On Sat, Nov 06, 2010 at 10:06:35AM +0100, Marco Stornelli wrote:
>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>
>>>> During compilation of 2.6.36 for Beagle board, there a are a couple of warnings. This patch fix them.
>>> Please break lines for commit logs at around 76 chars and mention the
>>> exact compiler warning being fixed.
>>>
>>
>> My compiler version is gcc 4.4.1. Two warning: variable gpio_mux may
>> be used not initialized (false positive, I agree); second: compiler
>> fix the void lack in the inline function with an int. Obviously there
>> is a lack of return type that it must be void.
>>
>
> Marco,
>
> Both of these are fixed in 2.6.37-rc1.
>
> Commits afc28bc0ec and ca828760f9 respectively.
>
> - Anand
>

Very good. Thanks.

Marco
