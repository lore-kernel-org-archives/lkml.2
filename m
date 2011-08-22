Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1HVJsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:48:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52435 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HVJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110822082700.GK12028@n2100.arm.linux.org.uk>
References: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com>
	<20110817090123.GD1006@n2100.arm.linux.org.uk>
	<CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com>
	<CACRpkdYw96QD0sGOhA=osKYbnD6=MTqiAF=m5++BjM-s1Mn--w@mail.gmail.com>
	<CACxGe6tEOnUzFjKMqNfp10b8SyuJDDFzg0eiPzhKNNCY55LECw@mail.gmail.com>
	<CACRpkdbPFuFHBuHzO2bP+z=za2kOFk4AZdgMVy=U6kcMmw9LSw@mail.gmail.com>
	<20110822082700.GK12028@n2100.arm.linux.org.uk>
Date: Mon, 22 Aug 2011 11:48:08 +0200
Message-ID: <CACRpkdbKBGVLwLjcnHi3dsiL_DzePHiV2NWb=ksHD=xcDDhmUA@mail.gmail.com>
Subject: Re: [PATCH 00/19] GPIO exodus and cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 10:27 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> [Me]
>> Tell me if I should rebase on something specific or if there are
>> any problems.
>
> I've applied as many as I can, but 7042/1, 7046/1, 7047/1 and 7048/1
> failed:

Since I worked on top of -next that would seem to indicate that there will
be colissions with one or other tree so I'd say let's hold these back FTM.

I'll track them for the next merge window or so.

Thanks Russell!
Linus Walleij
