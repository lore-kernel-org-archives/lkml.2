Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab2DJTWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:22:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45049 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2DJTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:22:54 -0400
Message-ID: <1334085769.6046.8.camel@flow>
Subject: Re: [PATCH v2] mfd: asic3: Set DS1WM clock_rate
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Date: Tue, 10 Apr 2012 21:22:49 +0200
In-Reply-To: <1333973911.59189.YahooMailClassic@web29014.mail.ird.yahoo.com>
References: <1333973911.59189.YahooMailClassic@web29014.mail.ird.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 09.04.2012, 13:18 +0100 schrieb Paul Parsons:
> The mfd/asic3 driver does not set the ds1wm_driver_data clock_rate field
> before passing the structure to the DS1WM w1 busmaster driver.
> This was not noticed before commit 26a6afb, because ds1wm_find_divisor()
> unintentionally returned the correct divisor when a zero clock_rate was
> passed in. However after that commit DS1WM fails a zero clock_rate:
> 
> ds1wm ds1wm: no suitable divisor for 0Hz clock
> 
> This patch sets the ds1wm_driver_data clock_rate field.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> ---
> 
> V2:
> Separated arch/arm/mach-pxa/hx4700.c changes into a separate patch,
> to avoid crossing maintainer boundaries.
> This patch now submitted to linux-kernel instead of linux-arm-kernel.
> Rebased from linux-3.0.1 to linux-3.4-rc2.

Acked-by: Philipp Zabel <philipp.zabel@gmail.com>

regards
Philipp

