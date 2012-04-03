Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2DCC5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:57:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50618 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2DCC5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:57:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
Date: Tue, 3 Apr 2012 11:57:14 +0900
X-Google-Sender-Auth: DjGrLcggTudJQ8LcF_qqbfg1p5g
Message-ID: <CAH9JG2Wha0+6BwGW0APtEX2KACyR1+9fdKpJkM+iOU1m8N6d4w@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Kyungmin Park <kmpark@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, hdoyu@nvidia.com, konrad.wilk@oracle.com,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 8:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Ok, it's been two weeks, and the merge window is over. Linux 3.4-rc1
> has been pushed out to the git servers, and the tar-ball and patches
> are going out as I type this (probably done by the time I'm done).
>
> And yes, if you actually counted, it has only been 13 days. And if
> somebody delayed their pull request until the last day of the merge
> window, I'm sure they'll be even happier to delay it another two
> months until the next merge window. Yay!
>
> That said, there are four pull requests in my mailbox that weren't
> delayed, and that I will (probably) still pull, but that I wanted to
> get extra confirmation from *other* maintainers from first. So they
> were sent in time, I just decided that I can make the actual pull
> choice a bit later.
>
> The four remaining pull requests (and the people I want comments from) are:
>
>  - HSI (High Speed Synchronous Serial Interface) framework. I'm
> planning on pulling this into 3.4, it's in my queue, but I wanted to
> bring it up one more time in case somebody has issues with it. Ping?
>
>  - pohmelfs. The old pohmelfs got deleted from staging, there's an
> all-new one waiting in the sidelines. Al was a bit unhappy about some
> of it, Evgeniy fixed it up some, and then the discussion died. Again,
> I'm likely to pull this, but I wanted more commentary on it.
>
>  - drm dma-buf prime support. Dave Airlie sent me the pull request but
> didn't push very hard for it, it's in my "ok, I can still pull it for
> 3.4 if individual DRM driver people tell me that it will make their
> lives easier." So this is in limbo - I have nothing against it, but I
> won't pull unless I get a few people say "yes, please".
>
>  - DMA-mapping framework. The tree now has a few more acks from
> people, and it's largely in the same situation as HSI is: I'll
> probably pull, but I really wanted the users who are impacted to
> actually talk to me about it.
>
Hi,

Now Marek and Nvidia persons are used it for DMA mapping based IOMMU.

Are there other person who help to merge it?
(+CC related persons).

Thank you,
Kyungmin Park
