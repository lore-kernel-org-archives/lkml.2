Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1DKJDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:03:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33859 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1DKJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:03:20 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikwCveocjPdoMoLEVpNneKkq66s4g@mail.gmail.com>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
	<BANLkTikZVDejarZ4O5KgNS7S4fxBLSmANA@mail.gmail.com>
	<BANLkTikVeXvfSBS-xLDXVdesKJpKdtUVqg@mail.gmail.com>
	<BANLkTikwCveocjPdoMoLEVpNneKkq66s4g@mail.gmail.com>
Date: Mon, 11 Apr 2011 11:03:18 +0200
Message-ID: <BANLkTikoj6UTx08ntZaMM15taKRXjrU_Mg@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mmc: use nonblock mmc requests to minimize latency
From: Per Forlin <per.forlin@linaro.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Jae hoon Chung <jh80.chung@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2011 05:33, anish singh <anish198519851985@gmail.com> wrote:
>
>
> On Sat, Apr 9, 2011 at 5:25 PM, Jae hoon Chung <jh80.chung@gmail.com> wrote:
>>
>> Hi Per..
>>
>> I'm applied your patch..and sent the patch about dw_mmc.c.
>> I think good this approach..
>
> Forlin,i too want to test this patch of yours but unfortunately i have
> samsung board+SDHCI host controller so i guess i just need to write pre_req
> and post_req functions and that would enable this(nonblock mmc request) on
> my board.Hope i am right?
You are right. The  SDHCI driver should work just fine without
implementing pre_req and post_req but you wont see any performance
increasing for DMA usage.
In order to benefit from the patchset you need to implement pre_req
and post_req.

If you run into trouble implementing those hooks or if you have any
questions please let me know.

Regards,
Per
