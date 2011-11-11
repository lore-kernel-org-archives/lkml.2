Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1KKG7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 01:59:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33762 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1KKG7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 01:59:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EBC4C27.3070400@gmail.com>
References: <CAM8FrKJ8OeavZxTBJBONw76UBBzS_mQYMZuS6Chf8+Po6yqDgA@mail.gmail.com>
	<4EBC4C27.3070400@gmail.com>
Date: Fri, 11 Nov 2011 07:59:17 +0100
Message-ID: <CAM8FrKKAz6okqX+SxwmgCvqQpBmYwVYLWxqbVQ36q4o2T1gX5g@mail.gmail.com>
Subject: Re: ioremap on system memory
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/10 Ryan Mallon <rmallon@gmail.com>
>
> On 10/11/11 19:06, Marcus Folkesson wrote:
>
> > Hi,
> >
> > I'm working with a custom based platform based on OMAP-L138.
> > A driver we are using is ioremapping system memory. It does this to
> > share data between the GPP and DSP core.
> > This is not allowed in later kernel versions since ARMv6+ does not support this.
> >
> > Is there any good(and easy) way to get around this or is it so
> > fundamentally wrong that the driver should be written from scratch?
>
>
> Cc'ed the ARM kernel list and Marek Szyprowski (CMA developer). The CMA
> patches I think do what you want, but I am not sure if they are merged
> yet. The other solution (again, I'm not an expert on this area) is to
> not pass the region of memory you want to manage as part of Linux's
> normal system memory. See how the OMAP framebuffer driver reserves a
> region of SDRAM (arch/arm/plat-omap/fb.c).
>
> Some one else on the ARM list can probably explain in more detail.
>
> ~Ryan
>

Not passing the region of the concerned memory seems to solve the problem.
Thank you!

Med vänliga hälsningar / Best regards
Marcus Folkesson
