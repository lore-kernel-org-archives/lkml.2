Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0HPMoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:44:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42615 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0HPMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TzQQ0igUb1h/pOd1iJ7Rgp/TWnPwP0i/EofSjYXqZwQWJKG4YagAK6fcRcNMxzhGrH
         gkxnIcOBh+Rj+1T4vMMpNwAvuk74f/S4E0Pywe4Gw8Yfq6xqu0p+l0FZcYgldo7GbBtF
         zp+6uN6uBVsdsYbwJ51Zfj/8NpRoksl/o4m5c=
MIME-Version: 1.0
In-Reply-To: <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
References: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com> <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 16 Aug 2010 20:44:03 +0800
Message-ID: <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com>
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8
To: Lei Wen <leiwen@marvell.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Haojian Zhuang <hzhuang1@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 8:34 PM, Lei Wen <leiwen@marvell.com> wrote:
> Hi Axel,
>
> I suggest not merge your patch into mainline code. Since I have a large series of patch which reconstruct the nand flash definition, this fix would no longer be needed.
>

Lei, would you please point the URL of the patch series (possibly by
searching linux-mtd archive or some other mailing list archive) so that
Axel can have a reference and be involved?

- eric
