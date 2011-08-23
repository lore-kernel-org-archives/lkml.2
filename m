Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1HWIRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:17:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43518 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1HWIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
Date: Tue, 23 Aug 2011 10:17:31 +0200
Message-ID: <CACRpkdY6KW+tv7H==b15xJyeLp9HCqp9ROBhON0A8JnJDUn8Kg@mail.gmail.com>
Subject: Re: [PATCH V3 00/20] dmaengine/amba-pl08x updates
From: Linus Walleij <linus.walleij@linaro.org>
To: vinod.koul@intel.com, Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, alim.akhtar@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 12:02 PM, Viresh Kumar <viresh.kumar@st.com> wrote:

> This patchset contains patches for ARM's pl08x DMA controller driver.
> Main changes introduced by this patchset are:
> - Formatting fixes
> - Logical Fixes
> - Support for Peripheral as flow controller
> - Support for sg_len to be greater than 1 for slave transfers
> - Schedule tasklet for error interrupts
> - remove pl08x_pre_boundary() routine
> - support for runtime PM
> - etc

I've now tested this patchset:

patch 3/20 fails to apply cleanly, need rebase on top of Russell's
fix for dma-mapping.h inclusion. It's a trivial fix.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Vinod could you apply all patches except for 16/18 which has some
discussion going on, so we get some rotation in -next? The rest of
Viresh:s patches are really nice stuff to have.

I will test on the PB11MPcore in the next few days.

Yours,
Linus Walleij
