Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1CGQC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:02:56 -0500
Received: from lebrac.rtp-net.org ([88.191.135.105]:35682 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1CGQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:02:54 -0500
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
	<87oc5puwg3.fsf@lebrac.rtp-net.org>
	<56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
Date: Mon, 07 Mar 2011 17:02:28 +0100
In-Reply-To: <56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
	(Nguyen Dinh-R's message of "Mon, 7 Mar 2011 15:37:38 +0000")
Message-ID: <87fwqyvrzf.fsf@lebrac.rtp-net.org>
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
> Just to verify that you are testing on an MX51-Babbage board? Here's my log:

I never said I was testing on babbage. The reason is because I'm using a
efika smartbook and not a babbage.

>
> root@freescale ~$ uname -a
> Linux freescale 2.6.38-rc1+ #93 Fri Mar 4 17:18:15 CST 2011 armv7l GNU/Linux

2.6.38-rc1+ ? which tree are you using ? The for-next branch of Sascha
Hauer's tree is at least 2.6.38-rc5 so you're trying to merge something
without even testing it on the current tree. Can you please test suspend
with current imx for-next tree (with no other patches than theses 2
patches if possible), in order to make sure that it's still working with it ?

Thanks,
Arnaud
