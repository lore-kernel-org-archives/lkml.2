Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0KJNSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:18:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63298 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0KJNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:18:43 -0500
Message-ID: <4CDA9BAE.6020709@monstr.eu>
Date: Wed, 10 Nov 2010 14:18:38 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: John Linn <John.Linn@xilinx.com>, spi-devel-general@lists.sourceforge.net,
        richard.rojfors@mocean-labs.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6> <4CD7FB27.9030804@monstr.eu> <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local> <AANLkTinMoqqMKeEFiD=xHwa5DS+5qY6xN2r236SZQEba@mail.gmail.com>
In-Reply-To: <AANLkTinMoqqMKeEFiD=xHwa5DS+5qY6xN2r236SZQEba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Mon, Nov 8, 2010 at 9:34 AM, John Linn <John.Linn@xilinx.com> wrote:
>>> -----Original Message-----
>>> From: Michal Simek [mailto:monstr@monstr.eu]
>>> Sent: Monday, November 08, 2010 6:29 AM
>>> To: grant.likely@secretlab.ca
>>> Cc: spi-devel-general@lists.sourceforge.net; richard.rojfors@mocean-labs.com; John Linn; linux-
>>> kernel@vger.kernel.org
>>> Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
>>>
>>> Hi Grant,
>>>
>>> Grant Likely wrote:
>>>> Since of_platform_bus_type has been merged with the platform_bus_type,
>>>> a single platform driver can now support both use cases.  This patch
>>>> series merges the two halves of the xilinx_spi device driver.
>>>>
>>>> Compile tested only.  I haven't booted this yet.
>>> I have tested it on sp605 and works well. Have you added that patches
>>> to your repository? Or are they somewhere else? Who is responsible for?

Grant: Can you answer my questions?

That our patch about DMA should follow your three patches.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
