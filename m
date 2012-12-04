Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2LDLKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:10:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2LDLKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:10:38 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.12.145]
In-Reply-To: <20121204110655.GE18368@8bytes.org>
References: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au> <20121204110655.GE18368@8bytes.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 4 Dec 2012 13:10:16 +0200
Message-ID: <CAK=WgbYDKN1deDTw3KvymvhoE1h_apX2E8zK=cDbu68+Gwcayw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the iommu tree
To: Joerg Roedel <joro@8bytes.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Mike Turquette <mturquette@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 1:06 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Dec 04, 2012 at 03:42:03PM +1100, Stephen Rothwell wrote:
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/mach-omap2/clock44xx_data.c between commit 298ea44f211d ("ARM:
>> OMAP4: hwmod data: ipu and dsp to use parent clocks instead of leaf
>> clocks") from the iommu tree and commit 13a5b6228679 ("ARM: OMAP44xx:
>> clock: drop obsolete clock data") from the arm-soc tree.
>>
>> I just deleted the file as the latter did and can carry the fix as
>> necessary (no action is required).
>
> Ohad, Omar, any comment on this?

I'd prefer Omar or Paul to have a look here. Looping in Tony as well.

Ohad.
