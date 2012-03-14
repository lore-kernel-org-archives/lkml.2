Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab2CNA7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:59:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59777 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2CNA7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:59:07 -0400
Date: Wed, 14 Mar 2012 04:59:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH 0/4] AB8500 Battery Management Driver
Message-ID: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
References: <1330532668-5673-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1330532668-5673-1-git-send-email-arun.murthy@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arun,

On Wed, Feb 29, 2012 at 09:54:24PM +0530, Arun Murthy wrote:
> Technical reference manual is available at
> http://www.stericsson.com/developers/CD00291561_UM1031_AB8500_user_manual-rev5_CTDS_public.pdf
> 
> AB8500 battery driver consists of
> 	Generic charging algorithm(abx500-chargalg.c)
> 	Charger driver(ab8500-charger.c)
> 	Fuel Gauge driver(ab8500-fg.c)
> 	Battery temperature driver(ab8500-btemp.c)
> The power supply class driver can act as a supply as well as supplicant. Any
> state change in one power supply class driver can be notified to its
> supplicants using notification mechanism provided by Power Supply Class frame
> work. Each Power supply class driver lists its supplicant names in "supplied_to"
> struct member, and each power_supply_changed() call issued by power supply class
> driver will notify supplicants via external_power_changed callback.

A complex thing! Thanks for the driver, it's now applied.

p.s.
Would be nice if you have told that it depends on MFD changes
(i.e. is_ab8500_1p1_or_earlier() thing). :-) It builds with
linux-next (w/ a few small fixups, I'll send them as follow ups),
so it's fine.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
