Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2D1M7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 08:59:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41840 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2D1M7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 08:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
Date: Sat, 28 Apr 2012 14:59:33 +0200
Message-ID: <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
From: Linus Walleij <linus.walleij@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:15 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> If no platform data at all is supplied the driver crashes,
> extend the checks to be more careful so we can compile in the
> driver and boot also without platform data present.
>
> Cc: Arun Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Anton have you picked these three patches for the -rc:s?

It seems Lee Jones is facing the problems so would be nice to
have this upstream.

Yours,
Linus Walleij
