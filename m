Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1HSQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:21:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41417 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab1HSQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:21:07 -0400
Date: Fri, 19 Aug 2011 20:21:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dima Zavin <dima@android.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: add support for using otg transceiver events
Message-ID: <20110819162101.GB22761@oksana.dev.rtsoft.ru>
References: <1310338875-24686-1-git-send-email-dima@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310338875-24686-1-git-send-email-dima@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 04:01:15PM -0700, Dima Zavin wrote:
> If the platform data sets the use_otg_notifier flag,
> the driver will now register an otg notifier callback and listen
> to transceiver events for AC/USB plug-in events instead. This would
> normally be used by not specifying is_xx_online callbacks and
> not specifying any irqs so the state machine is completely driven
> from OTG xceiver events.
> 
> Signed-off-by: Dima Zavin <dima@android.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
