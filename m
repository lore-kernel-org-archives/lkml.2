Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2IQNoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:44:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52952 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2IQNoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:44:01 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF514F@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF514F@DQHE02.ent.ti.com>
Date: Mon, 17 Sep 2012 15:44:00 +0200
Message-ID: <CACRpkdYQ8X7iwvHoecwYs1TZG_yP281FR-ZN7JCO=HUVp-05Ew@mail.gmail.com>
Subject: Re: Question about cleaning up the LP5521/5523 LED driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 1:28 PM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Should I keep the sysfs layout of LP5521 and LP5523?
> When we change the device attributes, do we have to consider the backward compatibility?

The ABI is a contract so basically yes, you need real good reasons
(like security concerns) to change the ABI.

That said, the lm3533 is the only LED driver that has actually documented
its ABI: Documentation/ABI/testing/sysfs-class-led-driver-lm3533

Yours,
Linus Walleij
