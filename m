Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276Ab0J0NkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:40:01 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:53337 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761262Ab0J0NkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:40:00 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Oct 2010 09:39:59 EDT
Message-ID: <4CC82A13.8000909@eukrea.com>
Date: Wed, 27 Oct 2010 15:33:07 +0200
From: =?ISO-8859-15?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com>	<20101027082958.GA6797@angua.secretlab.ca>	<20101027090921.GB8554@pengutronix.de>	<20101027102253.GA7822@angua.secretlab.ca> <20101027132213.GJ6017@pengutronix.de>
In-Reply-To: <20101027132213.GJ6017@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3031766976237448593
X-Ovh-Remote: 82.240.38.71 (pac33-2-82-240-38-71.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.50001/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 27/10/2010 15:22, Sascha Hauer a écrit :
 > That's a way we can go but only if the common name is not MX5 or MX5x.
 > We've done it with the mx21/27 and it failed when the mx25 came out
 > which was completely incompatible. Since then everybody looking at
 > the code must know that mx2x is mx21/27 but not mx25. I suggest
 > something like MX513 instead.
 >
MX513 is the partnumber of a member of the i.MX51 family so that's maybe not 
the best choice.
http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=i.MX513

Eric
