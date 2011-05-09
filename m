Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1EITfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:35:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64632 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1EITfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H1p1xNcFsdW5uJUECZDwvONwM5q36hFnyIv2sH4/E5hNPxBVG8ZtCh9G+hNhyZUghJ
         pH1GZt2t07RduGXFtd0BvvpLVKEZFzzuK1vJyu4P/0wqXnOV0pTA+r1bDT0AbcK8dieU
         8Bwd5sVgfMFtRRUUQDGXrwXkdbdjKG/O9oz5k=
MIME-Version: 1.0
In-Reply-To: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
References: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
Date: Mon, 9 May 2011 21:35:37 +0200
Message-ID: <BANLkTikUUUUU90Kd53qW=DyX6f8pdjakdw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] s3c2440: mini2440: Add missing code parts to be
 fully working with latest kernel.
From: Belisko Marek <marek.belisko@gmail.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 3:01 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
> changes from v1 to v2: Replace original patch [4] with generic leds-gpio driver.
>
> Patch add new LCD panels with which was board produced. Also add touchscreen
> support. Enabling LCD backlight during early booting stage also added.
>
> Some code parts are collected or inspired from other code (authors are in CC).
>
> Marek Belisko (4):
>  s3c2440: mini2440: Add support for new LCD panels.
>  s3c2440: mini2440: Add touchscreen support for mini2440.
>  s3c2440: mini2440: Select touchscreen by default.
>  s3c2440: mini2440: Use leds-gpio driver for board leds handling.
>
>  arch/arm/mach-s3c2440/Kconfig         |    1 +
>  arch/arm/mach-s3c2440/mach-mini2440.c |  176 ++++++++++++++++++++-------------
>  2 files changed, 107 insertions(+), 70 deletions(-)
Sorry but I received no objections on this patches (no objections for
any patch previously send to mach-mini2440).
Ben could you please apply this serie to get full mini2440 support
mainstream or?
>
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
