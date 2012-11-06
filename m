Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KFNzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:55:12 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:47282 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898Ab2KFNzJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:55:09 -0500
References: <50924DA3.1060901@ti.com> <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com> <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com> <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com> <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com> <20121102112104.4657fb7b@pyramind.ukuu.org.uk> <0EC43413-1DD7-4E2A-879B-0B5B926FFDFE@antoniou-consulting.com> <CACxGe6uuK6ew5uxh0BjtYAtPZCTLeUpHc4emXRAnMUtNmEzmGg@mail.gmail.com> <AC5129F0-FF30-46ED-AD57-3FA6CA919F99@antoniou-consulting.com> <CACxGe6v9cyybV4+5tQJ-DG8qdyEHfsLa7t+-3CTL+97Q9msrFw@mail.gmail.com> <18667A4E-5513-4D74-922F-30D091609F16@antoniou-consulting.com> <CACxGe6uR5VhHsCS1vmayURkGBKmhagaeWBBaCnyfsfOjZ2Dutg@mail.gmail.com> <CAD=GYpYc9L5yKqgar5jB2jG8+GiX7Lb0zevP9Pxaq0HdaVXQ5Q@mail.gmail.com> <CAD=GYpYsc4
 JrHiZfT9PzQQfas+=+emb=RLzvXV=Ec4JHKKK0AA@mail.gmail.com> <4DA29B25-C056-4360-8768-05585485FE00@antoniou-consulting.com> <CACxGe6sCroK2ztbrZG6u=2Fp7b8kuGDxJ94TNdpLtLNkhyHQcA@mail.gmail.com>
In-Reply-To: <CACxGe6sCroK2ztbrZG6u=2Fp7b8kuGDxJ94TNdpLtLNkhyHQcA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <F2ABBA86-3E97-4B2E-9FE5-FFAD8DDC9B88@antoniou-consulting.com>
Cc: Joel A Fernandes <agnel.joel@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <robherring2@gmail.com>
X-Mailer: iPhone Mail (10A523)
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Date: Tue, 6 Nov 2012 14:54:59 +0100
To: Grant Likely <grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Από το iPhone μου

6 Νοε 2012, 12:16, ο/η Grant Likely <grant.likely@secretlab.ca> έγραψε:

> On Tue, Nov 6, 2012 at 8:14 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> On Nov 6, 2012, at 4:06 AM, Joel A Fernandes wrote:
>>> Sure, so if we add data type supplementary properties to the tree to
>>> indicate the data type as "indirect phandle", then kernel could refer
>>> to the index in the got-like table to fetch the actual phandle address
>>> (1-level of indirection), instead of directly using the address in the
>>> data field.
>> 
>> I'm fine with this.
> 
> But if the data about phandles is already in the tree, then the need
> for a GOT simply goes away. The phandles can be fixed up directly and
> it is so much better because it works with existing parsing code after
> the merge is applied.
> 

Either way works. It is your call after all. 
I agree that your method is simpler. 
> g.

Regards

-- Pantelis