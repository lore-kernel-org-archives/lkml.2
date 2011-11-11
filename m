Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1KKJo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:44:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1KKJo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1320735864.git.viresh.kumar@st.com>
References: <cover.1320735864.git.viresh.kumar@st.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 11 Nov 2011 15:13:46 +0530
X-Google-Sender-Auth: ugeaHBTDYZffkeDY_EXiTcwELBY
Message-ID: <CAH+eYFAsLVU8A=m1Y1xm2YDRXhL1EGzxB-OcNQNd+w0tjMBZPA@mail.gmail.com>
Subject: Re: [PATCH 0/2] mfd/stmpe: Add SPI interface support
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com, bhavna.yadav@st.com,
        vincenzo.frascino@st.com, mirko.gardi@st.com,
        srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 12:35, Viresh Kumar <viresh.kumar@st.com> wrote:
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
>
> Viresh Kumar (2):
>  mfd/stmpe: separate out controller and interface specific code
>  mfd/stmpe: Add support for SPI interface

Could you instead convert stmpe to use the register map API, and then
add the SPI interface?  Converting to regmap should both simplify the
existing code as well as make it possible to add the second interface
with fewer lines of code.
