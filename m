Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1G0RO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:14:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38825 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1G0ROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
References: <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	<CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	<CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	<CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	<CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
Date: Wed, 27 Jul 2011 22:44:53 +0530
Message-ID: <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2011 22:06, Williams, Dan J <dan.j.williams@intel.com> wrote:
> On Wed, Jul 27, 2011 at 7:50 AM, Jaswinder Singh
> <jaswinder.singh@linaro.org> wrote:
>> On 27 July 2011 15:29, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
>>
>>> As the caps are not per channel, that is the only way I was able to make it
>>> work.
>> FWIW, my proposal(in other thread) tags capabilities to a channel.
>>
>
> Where is that other thread?
>

<copied from my reply to vinod >

I request you to please have a look at

1) What I propose
       http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059212.html

2) Why RMK thinks I am the biggest idiot on earth
       http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059217.html

3) How I ask for better proof of that
      http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/059223.html


Please give more serious look to what I called 'overall approach' in
the first post.
Implementation is secondary.

Thanks,
Jassi
