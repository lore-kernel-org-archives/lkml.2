Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1KHIoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:44:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47684 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1KHIoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1320735864.git.viresh.kumar@st.com>
References: <cover.1320735864.git.viresh.kumar@st.com>
Date: Tue, 8 Nov 2011 09:43:59 +0100
Message-ID: <CACRpkdaLoNLunftDJuXKX7W1bVFtsqyR9Ux5EDWxse1bryA32A@mail.gmail.com>
Subject: Re: [PATCH 0/2] mfd/stmpe: Add SPI interface support
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com, srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 8:05 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> Few STMPE controller can have register interface over SPI or I2C. Current
> implementation only supports I2C and all code is present in a single file
> stmpe.c.
>
> This patchset separates out code into three files
> - stmpe: specific to controller only
> - stmpe-i2c: specific to i2c interface
> - stmpe-spi: specific to spi interface
>
> In order to rebase it cleanly, please apply earlier floated patch
>        "mfd/stmpe: Add support for irq over gpio pin"

Patches look clean and nice to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
