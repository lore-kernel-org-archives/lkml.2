Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2IGIVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:21:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52683 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2IGIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAJOA=zM-u5ss8ZYWFHg43V7r5B6TXhRN70=JUccNjrppx4fDyg@mail.gmail.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
	<1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
	<20120831192906.31162.97714@nucleus>
	<CAPDyKFrS7tKu5AcjL7+R8V5Nvo0O+BVwc8HtGFqQGSf12wMioQ@mail.gmail.com>
	<20120907001927.20289.41627@nucleus>
	<CAJOA=zM-u5ss8ZYWFHg43V7r5B6TXhRN70=JUccNjrppx4fDyg@mail.gmail.com>
Date: Fri, 7 Sep 2012 10:21:02 +0200
Message-ID: <CACRpkdYVkQTH=205ggcauH7RbNPvpPEP+o12AK30wcpRWVnx4A@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: Provide option for clk_get_rate to issue hw for
 new rate
From: Linus Walleij <linus.walleij@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 3:00 AM, Turquette, Mike <mturquette@ti.com> wrote:
> On Thu, Sep 6, 2012 at 5:19 PM, Mike Turquette <mturquette@ti.com> wrote:
>> I'll take this series into clk-next.
>
> Oops, I forgot to ask about patch #3.  Which tree do you want that to
> go through?

Just take it all through your tree if there are no major conflicts.
Acked-by etc.

Yours,
Linus Walleij
