Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2IQNj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:39:58 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60868 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2IQNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
Date: Mon, 17 Sep 2012 15:39:56 +0200
Message-ID: <CACRpkdbHegZAw+9XXzOb5UPPqJvzoNfPJ5aPDhuwWWhWunuv8w@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add clk_{un}prepare() support in runtime PM
From: Linus Walleij <linus.walleij@linaro.org>
To: Vipul Kumar Samar <vipulkumar.samar@st.com>
Cc: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:37 PM, Vipul Kumar Samar
<vipulkumar.samar@st.com> wrote:

> clk_{un}prepare is mandatory for platforms using common clock framework. Add
> clk_{un}prepare() support for spi-pl022 runtime PM.
>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>

This driver does clk_prepare/unprepare at probe
and removed, so I guess what you're trying to say is that
on your platform the clk_unprepare() process context call
is needed to save power?

Please elaborate...

Yours,
Linus Walleij
