Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0HPORR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:17:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47871 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0HPORQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TcHOsZL9JHpRh7hxjKsADw6LsHTxLHp88JyzL2Ia124GPyKnR6C8xpqKeSWRrpUNnJ
         pfRo2VBQqdvjtfyIgJjh/OLlTS4fIyOhTYoI6QmgSzLBqzQLbGHxaWTy5MC3EdPGRZWN
         nMy7HMVb7ySAGdN6ibYDa3Qroz6UwZMhlywGo=
MIME-Version: 1.0
In-Reply-To: <53612FE6B944314AAADB181E45A45B64133DDFC162@sc-vexch3.marvell.com>
References: <AANLkTikCO505BZfqQGsRAdLgMa9hBQZ8YS-hJy-1RGg1@mail.gmail.com> <53612FE6B944314AAADB181E45A45B64133DDFC162@sc-vexch3.marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 22:16:54 +0800
Message-ID: <AANLkTimSqtpTemencLrKpRyHgSii0UYzH=FwawstDQmU@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
To: Lei Wen <leiwen@marvell.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Haojian Zhuang <hzhuang1@marvell.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/16 Lei Wen <leiwen@marvell.com>:
> Eric,
> The first patch is a bit of fundamental. I'm afraid that modify it would bring changes to all latter patches in this series...
>
> So I think I would repost another round of updating patch series and hope that would be merged. How do you think about this?
>

Please separate the patches into several patch series.

(PS: I'll possibly talk with you on this tomorrow F2F)
