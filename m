Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2KLLeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:34:22 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:50058 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab2KLLeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:34:21 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6uXyTt_kr4=0ob+-ubgV9he+SfobLwux6X0m6y7yQU7EA@mail.gmail.com>
Date: Mon, 12 Nov 2012 13:34:13 +0200
Cc: Benoit Cousson <b-cousson@ti.com>, Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AEFB103E-C71E-4A3C-B946-19ABD9025A17@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com> <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com> <5ED17D42-07B8-4D4F-B54F-82B4CC60584C@antoniou-consulting.com> <509A3595.7050600@ti.com> <A6697FB9-3614-4027-A71B-59C7556005BF@antoniou-consulting.com> <CACxGe6uXyTt_kr4=0ob+-ubgV9he+SfobLwux6X0m6y7yQU7EA@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 9, 2012, at 10:33 PM, Grant Likely wrote:

> On Wed, Nov 7, 2012 at 11:02 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> On Nov 7, 2012, at 11:19 AM, Benoit Cousson wrote:
>>> Maybe some extra version match table can just be passed during the board machine_init
>>> 
>>>      of_platform_populate(NULL, omap_dt_match_table, NULL, NULL, panda_version_match_table);
>>> 
>> 
>> Would we need explicit of_platform_populate calls if we have node modification notifiers?
>> In that case the notifier would pick it up automatically, and can do the per
>> version matching internally.
> 
> There still needs to be something to register "everything below this
> node is interesting" which is exactly what of_platform_populate() does
> now. I see the notifiers being used by the of_platform_populate
> backend to know when nodes have been created (or destroyed).
> 
> g.

I see. So of_platform_populate could just register the notifier and
not do the tree walk itself. Perhaps the name is a bit misleading then?

Regards

-- Pantelis

