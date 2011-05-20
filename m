Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1ETWKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:10:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab1ETWKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <1305502624-32418-1-git-send-email-linus.walleij@linaro.org>
References: <1305502624-32418-1-git-send-email-linus.walleij@linaro.org>
Date: Sat, 21 May 2011 00:10:22 +0200
Message-ID: <BANLkTimr+ebtvnpKvSWBo3BgNp+_+ACyoA@mail.gmail.com>
Subject: Re: [PATCH 00/13] Ux500 PRCMU into MFD v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 1:37 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> This moves the DB8500 PRCMU core driver from the
> arch/arm/mach-ux500/ dir to MFD, updates it, adds the missing
> DB5500 PRCMU driver, updates some dependent register files etc,
> and also updates the CPUfreq driver that use the PRCMU and moves
> it to drivers/cpufreq as discussed recently.

Hi Sam, is this patchset OK?

If I need to do any final adjustments for this merge window a good
time to tell me is now :-)

It's at the beginning of a large dependency chain for assorted
Ux500 drivers, that's why I'm so keen on getting this in place.

Linus Walleij
