Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3AJKtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:49:22 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55829 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3AJKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:49:21 -0500
MIME-Version: 1.0
In-Reply-To: <1356899374-9395-1-git-send-email-linux@prisktech.co.nz>
References: <1356899374-9395-1-git-send-email-linux@prisktech.co.nz>
Date: Thu, 10 Jan 2013 11:49:20 +0100
Message-ID: <CACRpkdagdO3_6DmKYaCwmx4Jju=E_uy86_QqdKLA3+VK7JNPjg@mail.gmail.com>
Subject: Re: [PATCH] gpio: vt8500: Export dedicated GPIO before multifunction pins.
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linux.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 9:29 PM, Tony Prisk <linux@prisktech.co.nz> wrote:

> The vendor does not provide numbering for gpio pins. Vendor source
> exports dedicated gpio pins first, followed by multifunction pins.
> As this is what end users expect, this patch changes vt8500 and wm8505
> to do the same.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

So how many existing userspace applications does this patch
break? Has this system been widely deployed so a kernel
upgrade will cause problems for people?

But applied anyway, unless someone screams about it real
soon now. That seems to be the only way to get people to tell
us about their use cases.

Could you consider adding names to the exported GPIO pins
on the vt8500 series please? Then userspace can atleast
try to locate the right pin.

Yours,
Linus Walleij
