Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1HNHa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 03:30:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44208 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1HNHa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 03:30:56 -0400
MIME-Version: 1.0
X-Originating-IP: [81.235.222.155]
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24F49@HQMAIL01.nvidia.com>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
	<20110809193405.GA4224@quad.lixom.net>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24F49@HQMAIL01.nvidia.com>
Date: Sun, 14 Aug 2011 00:30:55 -0700
Message-ID: <CAOesGMgEnh7VXHU568+sX7t=J46txGxV5M16Jx0UWUGJpD6=mg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ARM: Tegra: Harmony & Seaboard USB and audio
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 2:21 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Olof Johansson wrote at Tuesday, August 09, 2011 1:34 PM:
>> On Mon, Aug 08, 2011 at 02:35:12PM -0600, Stephen Warren wrote:
>> > This is a slight rev of some patches I posted a little while ago, now
>> > in a single series. The second patch has a minor revision that simplifies
>> > board-seaboard-pinmux.c.
>> >
>> > The (previous version of the) patches were previously Ack'd by Tegra
>> > maintainers, and Colin asked Arnd to pick them up in arm-soc.git,
>> > although I'm not sure if that request still holds given the merge
>> > window is over?
>>
>> Thanks, I've picked them up in boards-for-3.2, which will be merged in
>> through Arnd for 3.2.
>
> I see boards-for-3.2 isn't in linux-next itself, so these changes aren't
> getting rebased out of my local tree on top of linux-next.
>
> Does it make sense to add your tree into linux-next? Or, is the expected
> process that such trees will be quickly pulled/merged into Arnd's tree,
> which I assume is in linux-next?

Ah yeah, good point. I'll send a pull request to Arnd.


-Olof
