Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2LPLl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:41:56 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40691 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2LPLlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:41:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
Date: Sun, 16 Dec 2012 17:11:55 +0530
Message-ID: <CAKohpomhM=7zkbD8Dwt9FpDiJA+z0a3kafv66mFCUAShSX7rDA@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mike.turquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Linaro id of Mike]

On 16 December 2012 17:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
>> conversion so let's uninline the pair.
>>
>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Mike, are you taking these patches?
