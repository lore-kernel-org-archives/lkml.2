Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1C2HUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:20:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34190 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1C2HUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VZIKSz+DOwnq+/tVopOo3OnhLgsUS55SUfqNfrI1vup/28Hx5fxv/5PUaFA49tSI1y
         C/vLzWt1j9pNCiCCYW0Y2SX+aF9hSKDKuy3+xPFSU9fkBC2l8RCASDb5UNJlIcVGAOi4
         +x92UP9E3Hp+E5X5+sNBGnjwawr126K7/iS1o=
MIME-Version: 1.0
In-Reply-To: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
References: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
Date: Tue, 29 Mar 2011 08:20:19 +0100
Message-ID: <AANLkTin9PZuJpy4CizGvw4w6nexrdr1h+yPTU2vwjTBV@mail.gmail.com>
Subject: Re: [PATCH 0/4] s3c2440: mini2440: Add missing code parts to be fully
 working with latest kernel.
From: M P <buserror@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, esta1ien@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 7:32 AM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
> Patch add new LCD panels with which was board produced. Also add touchscreen
> support. Enabling LCD backlight during early booting stage also added.
>
> Some code parts are collected or inspired from other code (authors are in CC).

Actually, I'm not in CC, and most of this was from my own mini2440
tree on repo.or.cz, I'm also listed as maintainer at the bottom of the
mach-mini2440.c file.

Michael

> Marek Belisko (4):
>  s3c2440: mini2440: Add support for new LCD panels.
>  s3c2440: mini2440: Add touchscreen support for mini2440.
>  s3c2440: mini2440: Select touchscreen by default.
>  s3c2440: mini2440: Enable the backlight LED earlier at boot time.
>
>  arch/arm/mach-s3c2410/include/mach/leds-gpio.h |    1 +
>  arch/arm/mach-s3c2440/Kconfig                  |    1 +
>  arch/arm/mach-s3c2440/mach-mini2440.c          |   55 +++++++++++++++++++++++-
>  drivers/leds/leds-s3c24xx.c                    |    6 ++-
>  4 files changed, 60 insertions(+), 3 deletions(-)
>
>
