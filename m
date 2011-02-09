Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1BIMgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 07:36:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:63237 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1BIMgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 07:36:45 -0500
Subject: Re: [PATCH RESENT#2] [AVR32] don't check platform_get_irq's return
 value against zero
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288690250.32331.41.camel@hcegtvedt>
	 <1297247284-31650-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 09 Feb 2011 13:28:52 +0100
Message-ID: <1297254532.2968.11.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 09 Feb 2011 12:28:54.0106 (UTC) FILETIME=[EA2173A0:01CBC854]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 11:28 +0100, Uwe Kleine-König wrote: 
> platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> always true.  Better use (int)int_irq <= 0.  Note that a return value of
> zero is still handled as error even though this could mean irq0.
> 
> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> Hans-Christian Egtvedt asked to push this patch via Linus as there is no avr32
> tree.
> 
> @Andrew: do you take it?

Actually, now I have a tree for AVR32 on git.kernel.org, but I have no
other updates lined up for 2.6.38. Will you Andrew add it to your
series, or should I push this one through my git tree?

-- 
Hans-Christian Egtvedt

