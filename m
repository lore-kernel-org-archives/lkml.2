Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab0KHL7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:59:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38833 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0KHL7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DoWGoINMigwkaFoQ8K+ThKXaLshbOb35JUDGN6WQ0qOuDFWefZezvDwSnYRo9eNuBw
         /5i/HQVU+3J4nJRF1RtnKx/Uf8C3aLSiCOQkRegA/RMv6+KhXqOi3QfoDZgtiFBdXJSv
         5nDuD8XTX9qQqkkyAinNiWVEfdXh0NhX4xBI8=
MIME-Version: 1.0
In-Reply-To: <20101108091302.GO16938@pengutronix.de>
References: <4CD51A9B.7010806@gmail.com>
	<20101108091302.GO16938@pengutronix.de>
Date: Mon, 8 Nov 2010 12:59:06 +0100
Message-ID: <AANLkTinmQtrLJcjxRSwbHARrgE-4FEaJeDt4R8C2tLHY@mail.gmail.com>
Subject: Re: [PATCH] arm: fix compilation warning during compilation
From: Marco Stornelli <marco.stornelli@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Sanjeev Premi <premi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello,
>
> On Sat, Nov 06, 2010 at 10:06:35AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> During compilation of 2.6.36 for Beagle board, there a are a couple of warnings. This patch fix them.
> Please break lines for commit logs at around 76 chars and mention the
> exact compiler warning being fixed.
>

My compiler version is gcc 4.4.1. Two warning: variable gpio_mux may
be used not initialized (false positive, I agree); second: compiler
fix the void lack in the inline function with an int. Obviously there
is a lack of return type that it must be void.

Regards,

Marco
