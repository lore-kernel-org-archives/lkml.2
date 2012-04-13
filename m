Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2DMMfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:35:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38017 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2DMMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <1334199051.8736.3.camel@phoenix>
References: <1334199051.8736.3.camel@phoenix>
Date: Fri, 13 Apr 2012 14:35:48 +0200
Message-ID: <CACRpkda2M1CWJymf2QBmpKzVo_+UGMEV+sj2aF-vjbHStwrtAw@mail.gmail.com>
Subject: Re: [PATCH] mfd: Sort Kconfig entries for mfd drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 4:50 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Sort Kconfig entries by chip vendor name first, then driver name.
> Having the Kconfig entries sorted makes it easier for users to find the
> driver they want to enable.
> This change also encourages new coming drivers to be put in proper location
> rather than to be added at random location.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Samuel,
> I generate this patch against linux-next 20120411.
> If you think this patch is ok, pls apply this one and
> ignore my previous patch "mfd: Move MFD_TPS65090 and
> TPS65911_COMPARATOR Kconfig entries to proper location".

This is going to cause a number of merge conflicts for upcoming
patches from my side, I'd really like this to go into the -rc:s
if accepted so I can rely on it being present as a merge base.

Yours,
Linus Walleij
