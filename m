Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2LDALj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:11:39 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53570 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2LDALi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:11:38 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20121201132632.GA17981@opensource.wolfsonmicro.com>
References: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
	<1354165536-18529-3-git-send-email-ch.naveen@samsung.com>
	<20121129163448.GA3761@sirena.org.uk>
	<CAPnjgZ0atD3k=gT0vjgkLO_SA8DMak6SiT6nZ_2T6WFqtK0szQ@mail.gmail.com>
	<CAOesGMgE0JEHsdySpua34_kbWi1+z4n4UdW0kumiJEROi7O2pQ@mail.gmail.com>
	<20121201132632.GA17981@opensource.wolfsonmicro.com>
Date: Mon, 3 Dec 2012 16:11:36 -0800
Message-ID: <CAOesGMgzBGieYJ131sUX7u8EWPEusxareFzC0XPt48+oNuh-xA@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c-s3c2410: Add bus arbitration implementation
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        grundler@chromium.org, naveen@chromium.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 5:26 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Nov 29, 2012 at 10:14:58PM -0800, Olof Johansson wrote:
>> On Thu, Nov 29, 2012 at 6:13 PM, Simon Glass <sjg@chromium.org> wrote:
>
>> > It was originally done separately but I think it was felt that this
>> > was overly complex. Olof can you please comment on this?
>
>> it is indeed not controller specific per se, but we are unaware of any
>> other platform/driver using it. So, it seemed reasonable to implement
>> it in the driver as long as we have only one user; if another one
>> comes along it's of course better to move it to the common i2c code.
>
>> At least that was my opinion at the time. I could be convinced
>> otherwise if someone else has strong opinions on the matter.
>
> This sort of approach is half the reason SPI ended up being so fun...  I
> suspect if you look hard enough you'll find that this is just the first
> time someone tried to upstream such a scheme.  This is all especially
> true for the DT bindings, even if the implementation is driver local for
> now it'd be better to define generic bindings.

Ok, sounds like we might as well make it generic then. Naveen?


-Olof
