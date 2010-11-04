Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0KDUay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:30:54 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:39491 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751598Ab0KDUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:30:52 -0400
Message-ID: <4CD317E2.9090504@eukrea.com>
Date: Thu, 04 Nov 2010 21:30:26 +0100
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Nguyen Dinh-R00091 <R00091@freescale.com>
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        Zhang Lily-R58066 <R58066@freescale.com>, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
References: <1288736227-800-1-git-send-email-Dinh.Nguyen@freescale.com> <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com> <4CD12833.8060204@eukrea.com> <86A0E76937111F4C92FABEC0A20988510523CEC2@az33exm21>
In-Reply-To: <86A0E76937111F4C92FABEC0A20988510523CEC2@az33exm21>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1721219483821452548
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 04/11/2010 20:21, Nguyen Dinh-R00091 a écrit :
> Reading the ROM code is probably the most reliable way to get the correct
> silicon revision. Because the ROM that is on the chip is "most likely"
> up-to-date with the silicon. "Most likely" means that 95% of the time, when
> you get a new silicon, the ROM code will get updated. There is still a
> chance that a new silicon will not require a ROM update.
>
> Also the other reason is that sometimes the fuses that identify the silicon
> revision that are used by the IIM are sometimes not blown to reflect the
> correct revision in pre-production parts. MX51 is a post production part,
> so in theory, the fuses are blown correctly. But since we made MX51 boards
> available prior to going into production, reading from the IIM is not as
> reliable as reading the ROM.
>
Don't you think we should use the documented register which (if we believe the 
documentation) should be 100% reliable for production CPU instead of this 
undocumented method which from what you say is 95% reliable and here to handle 
the case of pre production CPU ?

The same problem occured on i.MX35 silicon 2.1 which where not correctly 
detected using the ROM code.

Eric
