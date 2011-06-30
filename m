Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1F3MlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:41:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40871 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1F3MlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <1309435714.23597.181.camel@sauron>
References: <1309408494.10500.1.camel@phoenix>
	<BANLkTikonD2fcbkBU2ESYm_XncBXNZc_hw@mail.gmail.com>
	<1309435714.23597.181.camel@sauron>
Date: Thu, 30 Jun 2011 16:41:02 +0400
Message-ID: <BANLkTik-pWfbC3J9LkB-jL9H8cnoLR=R-Q@mail.gmail.com>
Subject: Re: [PATCH] mtd: tmio_nand: fix build error
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: dedekind1@gmail.com
Cc: Axel Lin <axel.lin@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/11, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Thu, 2011-06-30 at 12:23 +0400, Dmitry Eremin-Solenikov wrote:
>> On 6/30/11, Axel Lin <axel.lin@gmail.com> wrote:
>> > Fix a mistake introduced by commit 33f4a3b
>> > "mtd: tmio_nand.c: use mtd_device_parse_register"
>>
>> Already sumbited 27 June 2011. Strangely Artem remains silent.
>
> I handle my mailbox in FIFO order (with exceptions) so I have not
> reached your patch yet. Now I've merged it with one of your previous
> patches to keep the kernel bisectable.

Thanks and sorry if my comment offended you! It's just I see most of
MLs/patches in threads, so I was a bit puzzled.

-- 
With best wishes
Dmitry
