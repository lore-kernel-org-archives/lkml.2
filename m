Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1KDQNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:13:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35909 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1KDQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
References: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
Date: Fri, 4 Nov 2011 12:13:50 -0400
Message-ID: <CAJuYYwRLoT2Xf8PcBPx_Nr1dYvki-aKVmkmsMy2r5z1wKu9r7Q@mail.gmail.com>
Subject: Re: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-ranges
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: linus.walleij@linaro.org, swarren@nvidia.com, Barry.Song@csr.com,
        Rongjun.Ying@csr.com, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Deepak Saxena <deepak.saxena@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanho Park,

On 28 October 2011 01:41, Chanho Park <chanho61.park@samsung.com> wrote:
> This patch enables mapping a base offset of gpio ranges with
> a pin offset even if does'nt matched. A "base" of pinctrl_gpio_range
> means a start offset of gpio. However, we cannot convert gpio to pin
> number for sparse gpio ranges just only using a gpio base offset.
> We can convert a gpio to real pin number using a new pin_base
> (which means a base pin offset of requested gpio range).
> If the pin_base is not specified explicitly, the controller sybsystem
> makes to equal with gpio's base offset. Now, a pinctrl subsystem passes
> the pin number to the driver instead a offset.

Just wanted to check with you if you have started the implementation
of pinctrl driver for Samsung platforms or do plan to start on it?

Thanks,
Thomas.

[...]
