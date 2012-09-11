Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2IKLA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:00:29 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:38221 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932140Ab2IKLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:00:25 -0400
Date: Tue, 11 Sep 2012 13:00:21 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Oskar Schirmer <oskar@scara.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] watchdog/imx2+: add support for pretimeout interrupt functionality
Message-ID: <20120911110021.GG27604@spo001.leaseweb.com>
References: <1338460658-16067-1-git-send-email-oskar@scara.com> <1347357652-23601-1-git-send-email-oskar@scara.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347357652-23601-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

> This watchdog device provides pretimeout facilities:
> Set some timeout value and get informed about imminent
> watchdog activity thru interrupt.
> 
> Allow user to wait for this interrupt thru poll(2),
> and to clear it thru read(2).
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>

I have a problem with the read and poll.
We had "read()" in the past so we have a possible issue here (different function but userspace apps could still use the old read)...
Can you explain what the read and poll does and where you want to use it.

Kind regards,
Wim.

