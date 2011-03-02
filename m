Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1CBTmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:42:44 -0500
Received: from lebrac.rtp-net.org ([88.191.135.105]:46375 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab1CBTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:42:43 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 14:42:43 EST
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: <Dinh.Nguyen@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Organization: RtpNet
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
Date: Wed, 02 Mar 2011 20:35:16 +0100
In-Reply-To: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
	(Dinh Nguyen's message of "Wed, 2 Mar 2011 11:17:58 -0600")
Message-ID: <8762s1xqmj.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Dinh.Nguyen@freescale.com> writes:

Hi,

> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.

I've very quickly tried suspend to mem on my system and despite having set
some irq as wakeup source, it doesn't wake up. Is there some extra step
to be done in order to test your patch ?

Moreover, the code I've seen for suspend is very different. It's seems
to handle some cpufreq stuff and seems to be copying some code into some
special ram. Is all this stuff unneeded ?

Arnaud
