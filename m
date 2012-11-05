Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2KEAht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:37:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KEAhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com>
References: <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
 <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
 <20121102112104.4657fb7b@pyramind.ukuu.org.uk> <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Nov 2012 00:37:25 +0000
X-Google-Sender-Auth: 9vXw_hgJ6OxeU7k3VFkDRrs5VrI
Message-ID: <CACxGe6uuK6ew5uxh0BjtYAtPZCTLeUpHc4emXRAnMUtNmEzmGg@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 12:32 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> The i2c2 alias cannot be resolved at compile time; there has to be
>
> a) A DT object format where unresolved aliases (symbols) are tracked
> b) A runtime DT linker that will resolve the alias, and will insert the
>    i2c2-devices child nodes as children in the i2c2 node.
> c) A method to trigger platform device creation for the child nodes just
>    inserted.
>
> DT core changes aren't bound to be easily accepted, so without having a clear
> signal from the DT maintainers that they would consider such a method people
> are just hesitant to go down this road.

I do agree and will accept such a method.

g.
