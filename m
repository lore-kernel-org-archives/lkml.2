Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0LAGVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:21:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55096 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0LAGVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Di6StY5vkouwZ0yPRqu9VBQq7pjtQrL17I0ezHzl7OXThhXwTuVMr2Io+2LQd7RzMS
         56eMLDIkca5CMK7NhtHz6qfS9kK+uSQHE7e0EhuPrBdKSg4wRghbxqu7oBC7yHcCvfEg
         6+Nzdljb1Num9V6wurKjFO8NQhMh53DHwVezo=
MIME-Version: 1.0
In-Reply-To: <20101130233204.GB14383@n2100.arm.linux.org.uk>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
	<20101130171658.GA24034@oksana.dev.rtsoft.ru>
	<20101130233204.GB14383@n2100.arm.linux.org.uk>
Date: Wed, 1 Dec 2010 11:51:42 +0530
Message-ID: <AANLkTi=WHBqq5U8OzkMaprk=vzphZBV0HhLEDF-uAZxW@mail.gmail.com>
Subject: Re: [PATCH 1/8] ARM: SCU: Add common routines for secondary CPU bootup
From: Srinidhi Kasagar <srinidhikasagar@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <avorontsov@mvista.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jamie Iles <jamie.iles@picochip.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 5:02 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 30, 2010 at 08:16:58PM +0300, Anton Vorontsov wrote:

[...]

>> +     sub     r4, r4, r5
>> +     add     r6, r6, r4
>> +#if __LINUX_ARM_ARCH__ >= 7
>> +     dsb
>> +#endif
>
> Another question though - probably for Linus though - why is the u8500
> code needing this dsb whereas other ARMv7 implementations don't appear
> to require it?

No strong reason, we can safely ignore this now.

srinidhi
