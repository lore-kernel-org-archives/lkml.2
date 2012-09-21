Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab2IUKKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:10:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33014 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab2IUKKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120919112614.GE8138@sortiz-mobl>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
	<20120919112614.GE8138@sortiz-mobl>
Date: Fri, 21 Sep 2012 18:10:37 +0800
Message-ID: <CAN1soZyk5gKi57HfE+_Ca0yj0=s-K37pX5+C_qn6kRnhkcAKtQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] mfd: update on 88pm860x and max8925
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:26 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Mon, Sep 17, 2012 at 12:19:03PM +0800, Haojian Zhuang wrote:
>> 1. Updates the patch of max8925 of building issue.
>> 2. Include Jett's PREG regulator patch.
>> 3. Support DT in 88pm860x.
>
> I applied the 5 first patches.
> For the regulator one, I'd like to get Mark's ACK as well.
>
> Patch #6 did not apply cleanly.
> Patch #7 needs some fixes and documentation addition.
> Patch #8 needs Dmitry's ACK
>
> And I can take patch #9 once #7 is in.
>

I updated those patches.

Thanks
Haojian
