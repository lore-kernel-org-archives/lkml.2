Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1CEUrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:47:24 -0500
Received: from lebrac.rtp-net.org ([88.191.135.105]:56826 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab1CEUrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:47:16 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer\@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig\@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>
Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
Organization: RtpNet
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
	<56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
Date: Sat, 05 Mar 2011 21:46:52 +0100
In-Reply-To: <56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
	(Nguyen Dinh-R's message of "Fri, 4 Mar 2011 23:33:11 +0000")
Message-ID: <87oc5puwg3.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nguyen Dinh-R00091 <R00091@freescale.com> writes:

> Hi Arnaud,

Hi,

>
> I just sent out a 2nd set of the MX51 LPM patch. I have tested successfully on my mx51 babbage without any code modifications.
>
> If you would kindly verify on your side, that would great.
>
> You need both patches:
>
> [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
> [PATCHv2 2/2] ARM: mx51: Add support for low power suspend on MX51

No success. I even tried disabling nearly all drivers and nothing. The
last line I have in the serial console is :

PM: late suspend of devices complete after 0.354 msecs

So, I still don't know if the system is crashing while suspending or if
the system is suspended but doesn't wake up.

Arnaud
