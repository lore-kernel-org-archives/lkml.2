Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2HTG4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:56:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37145 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2HTG4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <1345403092.1930.4.camel@kyv>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
 <20120816115713.726da8f2@pixies.home.jungo.com> <CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
 <20120816134234.32b468f6@pixies.home.jungo.com> <1345124012.3393.239.camel@sauron.fi.intel.com>
 <20120819100946.646cbb8a@pixies.home.jungo.com> <1345403092.1930.4.camel@kyv>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 20 Aug 2012 08:55:48 +0200
Message-ID: <CACQ1gAh7db9Dnqouzv5S=uAfTfavw45dwWSRAozGU4s7y8FA9w@mail.gmail.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter
To: dedekind1@gmail.com
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,
2012/8/19 Artem Bityutskiy <dedekind1@gmail.com>:
> Yeah, I wanted to make it 1..256 but forgot, will do now. 0..256 would
> need some more work to avoid division by 0.
Division by 0 is handled in the get_bad_peb_limit() function, I don't
see another dangerous place.
So, I think that we can change back the range to 0..256.
(and if we want to be coherent with user-space, it should be 0..255,
as the range is coded with an u8)

Richard.

-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
