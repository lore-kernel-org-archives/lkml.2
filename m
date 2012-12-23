Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2LWNVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 08:21:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47980 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2LWNVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 08:21:39 -0500
Date: Sun, 23 Dec 2012 14:21:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <bitbucket@online.de>
Cc: Norbert Preining <preining@logic.at>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: dire state of rtl driver in 3.7
Message-ID: <20121223132134.GA8190@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <bitbucket@online.de>,
	Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
 <1356241795.5620.47.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356241795.5620.47.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 06:49:55AM +0100, Mike Galbraith wrote:
> Looks a lot like my driver experience with older kernels, I had to use
> the external driver in the rare event that I needed wireless to work.
> The in tree driver works peachy these days (needed it recently, was
> pleasantly surprised when it _just worked_, not even a hiccup), so
> somebody cared, gave at least the 10ec:8181 bits some serious love.

Good for you.

I have a [10ec:8176] in my laptop and while I don't have the issues
Norbert is reporting, I can't say the thing just worked.

I had to use the wireless recently in a bunch of networks and what it
would do, is associate properly, connection gets established and traffic
is fine for a minute or so. Then, after a minute traffic would cease and
I'd need to re-associate. And it worked sporadically, sometimes fine,
sometimes with constant connection interruptions. And this observation
was the case with almost all wireless networks I'd use.

FWIW, the wifi adapter is:

01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8195]
        Flags: fast devsel, IRQ 17
        I/O ports at 3000 [size=256]
        Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00

using rtl8192ce.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
