Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1EUMCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:02:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55883 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1EUMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KtV7TSRYRCvzksm8vUyKl6KHiarVae2ksHkZdI8wLHFB4fuaeDUL5xenMLRgit14bg
         0D8iufhFTAyBLWt18dTUKL3tzQBqsc5isBcAdFbJ3oEzQlIjOkf2dV3wZmAsNi0g9p8h
         RiB/r60nIJmWa3E/pd0tnuQ/9nNKyf0+64Chk=
Subject: Re: PATCHv4 0/5] Add TPS65911 device
From: Liam Girdwood <lrg@kernel.org>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
In-Reply-To: <6713982D-EB98-4808-A03F-7E0C323B2531@slimlogic.co.uk>
References: <6713982D-EB98-4808-A03F-7E0C323B2531@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 13:02:34 +0100
Message-ID: <1305979354.3317.9.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 18:34 -0500, Jorge Eduardo Candelaria wrote:
> This is the initial version of the TPS65911 PMIC. This is a power management IC
> for multimedia products.
> 
> The driver is depends on the TPS65910 PMIC and provides the same functionality:
> Regulators, GPIO controller, RTC, etc. It also adds new functionality that was
> not present in TPS65910 chip.
> 
> Support for subsequent versions of this PMIC can be easily added after this set
> of patches.
> 
> Changes from v2:
> - Moved GPIO driver to drivers/gpio.
> - Determine the chip's number of gpios using a switch statement instead of if-else.
> - Remove Kconfig entry for comparator driver.
> 
> Changes from v3:
> - Separated GPIO changes in 2 patches:
>    - Move gpio driver to drivers/gpio
>    - Add support for tps65911
 
Now applied.

Thanks

Liam

