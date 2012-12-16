Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2LPMUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:20:47 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37140 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2LPMUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121216115756.GO14363@n2100.arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
	<20121216115756.GO14363@n2100.arm.linux.org.uk>
Date: Sun, 16 Dec 2012 17:50:44 +0530
Message-ID: <CAKohpok7Lh_ozuBFZdObpPRj0u_B-MNqgWjmaaSik3v4SmgJcw@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2012 17:27, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Dec 16, 2012 at 05:10:36PM +0530, Viresh Kumar wrote:
>> On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> > We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
>> > conversion so let's uninline the pair.
>> >
>> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>> Mike, are you taking these patches?
>
> And what about my comments, some of which you've failed to reply to?

Surprised!! I thought there was nothing missing after the last
discussion i remember.
Dmitry agreed to drop the first patch and all other looked fine, as
nobody objected
to them again. Yes, you did in the beginning but there were valid
replies to them, on
which you never objected.

So, i thought its all good now. Can you point again to the issues still left ?

--
viresh
