Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1HVJtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:49:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42326 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HVJs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110822092459.GL12028@n2100.arm.linux.org.uk>
References: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com>
	<20110817090123.GD1006@n2100.arm.linux.org.uk>
	<CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com>
	<CACRpkdYw96QD0sGOhA=osKYbnD6=MTqiAF=m5++BjM-s1Mn--w@mail.gmail.com>
	<CACxGe6tEOnUzFjKMqNfp10b8SyuJDDFzg0eiPzhKNNCY55LECw@mail.gmail.com>
	<CACRpkdbPFuFHBuHzO2bP+z=za2kOFk4AZdgMVy=U6kcMmw9LSw@mail.gmail.com>
	<20110822082700.GK12028@n2100.arm.linux.org.uk>
	<20110822092459.GL12028@n2100.arm.linux.org.uk>
Date: Mon, 22 Aug 2011 11:48:59 +0200
Message-ID: <CACRpkdZ3+mAA+KhELbFLZ5Z0yLXWSiFZjFCZk5L6tjeEe32jwg@mail.gmail.com>
Subject: Re: [PATCH 00/19] GPIO exodus and cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:24 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Looking through the gpio.h files, plat-nomadik's is virtually empty
> except for a copyright, ifdef and include of linux/kernel.h - can it
> be killed off entirely now?

I'll look into it ASAP.

Thanks,
Linus Walleij
