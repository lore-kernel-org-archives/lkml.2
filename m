Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758Ab2CVB2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 21:28:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47294 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030626Ab2CVB22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 21:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120228.223258.2261979237568571219.davem@davemloft.net>
References: <157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
 <20120228.212857.797446903975232476.davem@davemloft.net> <157393863283F442885425D2C454285619415561@nasanexd02a.na.qualcomm.com>
 <20120228.223258.2261979237568571219.davem@davemloft.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 21 Mar 2012 18:28:07 -0700
X-Google-Sender-Auth: fwNi4I6gp6viqYKGpPkGbCjmmfk
Message-ID: <CAB=NE6W-CYjEhbfYOv7XqXFGvdhZxRECqfAmgouaa5_j45gnOQ@mail.gmail.com>
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
To: David Miller <davem@davemloft.net>
Cc: xiong@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com,
        Jesper Andersen <jespera@diku.dk>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 7:32 PM, David Miller <davem@davemloft.net> wrote:
> From: "Huang, Xiong" <xiong@qca.qualcomm.com>
> Date: Wed, 29 Feb 2012 03:11:14 +0000
>
>> We understand your concern.  To support the new chipset, do you
>> think it's reasonable to upstream it as a new driver, not a
>> replacement ?
>
> It depends upon how similar the chips are.

OK.

> To be honest tg3, as one example, supports quite a large array of
> different pieces of hardware that use the same logical core.

At certain point it becomes a pain in the ass to support older
chipsets, and simply easier to leave the older driver to rot.

> So that would be my litmus test about how different a chip needs
> to be to deserve an entirely new driver.

Understood.

> I strongly suggest you try to get atl1c working properly.

This is what I have recommended since the alx driver was rejected, and
our team has been working on the atl1c driver now but we need to get
the legal approval to get contributions out to atl1c (I know this is
silly, but hey just letting you know).

Anyway, in the meantime another topic has creeped up, and that is to
share with BSD and also help kill proprietary drivers [0]. Me and
Adrian intend on sharing our thoughts on how we intend on doing this
at LF collab but was in hopes we can use alx as a test case. We've
gone back to the drawing board for another simple driver to test our
work against but... we come back to alx.

Would it be worthwhile to consider alx upstream only for the newer
chipsets (regardless of the litmus test, which I do agree with on
technical grounds) in consideration for helping pave the way on
killing proprietary drivers?

[0] https://events.linuxfoundation.org/events/collaboration-summit/rodriguez-chadd

 Luis
