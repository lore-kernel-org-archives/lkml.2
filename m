Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2KTSoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:44:00 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54381 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2KTSn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:43:58 -0500
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:9582:8241:8278:2cf3]
In-Reply-To: <1353432158-22999-2-git-send-email-dianders@chromium.org>
References: <1353432158-22999-1-git-send-email-dianders@chromium.org>
	<1353432158-22999-2-git-send-email-dianders@chromium.org>
Date: Tue, 20 Nov 2012 10:43:57 -0800
Message-ID: <CAOesGMiGZHAw0zOZFZcYJ9YngbcMsTJrzhG+DQ5sP9Sq+CyzDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: snow: Add board dts file for Snow board
 (ARM Chromebook)
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 9:22 AM, Doug Anderson <dianders@chromium.org> wrote:
> This dts file is based on the Snow dts file in the Chromium OS kernel
> tree with the following changes:
> * Some details have been updated to match the exynos5250-smdk5250.dts
>   file from linux-next (as of
>   c11068538994430547722dc9fb515a0ceefd5cb9).
> * This file doesn't include references to hardware whose upstream
>   support isn't quite there yet.  That includes most i2c devices.
>   Note that most i2c busses have been included with no devices.
>
> The Snow dts file is mostly just an include of the "cros5250" dts file
> which describes a class of similar boards.  Support for other boards
> has not yet been send upstream.
>
> With this file and a change to use UART3 for serial output I can:
> * Boot to a command line using either SD or EMMC as a root filesystem
> * See the power button and lid switch using evtest.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>

Kukjin, since your pull requests came in today, can you ack this and
I'll just apply it on top of your branches?


Thanks,

-Olof
