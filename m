Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2KIRDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:03:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61441 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2KIRDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:03:23 -0500
MIME-Version: 1.0
In-Reply-To: <B1277EA3-9284-4856-A7E8-1B1CA9D30327@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
 <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
 <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com> <B1277EA3-9284-4856-A7E8-1B1CA9D30327@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 17:03:02 +0000
X-Google-Sender-Auth: Bo4NG3bFNc0z3f_coYrgBV3IFB4
Message-ID: <CACxGe6vRm-8D5L2aD2QRB6qD0XkU302xThRd4G4ad-fLJxh-OA@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>, Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 8:06 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Hi Grant,
>
> On Nov 6, 2012, at 9:45 PM, Grant Likely wrote:
>> Yes, the locking does need to be sorted out.
>>
>
> Perhaps come up with a dt-stress test tool/boot time validator?

I would like that. I've started adding DT test cases to the kernel source tree.

g.
