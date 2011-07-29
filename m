Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1G2QAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:00:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1G2QA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <1311942777.1536.547.camel@vkoul-udesk3>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
	<20110729110525.GG25640@n2100.arm.linux.org.uk>
	<1311942777.1536.547.camel@vkoul-udesk3>
Date: Fri, 29 Jul 2011 08:58:48 -0700
Message-ID: <CAOh2x=kRz70etXbaCPO2HCysftyixai44=ZZdLAnZde5N5PmrA@mail.gmail.com>
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
From: viresh kumar <viresh.linux@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Fri, 2011-07-29 at 12:05 +0100, Russell King - ARM Linux wrote:
>> On Fri, Jul 29, 2011 at 04:19:20PM +0530, Viresh Kumar wrote:
> Typically in few dmac IPs i know of:
> There is max limitation of what a burst length can be for dma, and what
> a max transfer length can be.
> The dma will push/pull data into peripheral FIFO based on
> max_burst_length parameter (note length in dma terminology is always
> items not bytes, and one item is usually defined as
> transfer_length/src_width). For a transfer (single block or in
> multi-block) the dmac will break the transaction into multiple bursts
> and based on max_burst_length it will push/pull data to/from FIFO. Also
> matching FIFO thresholds with max_burst_length is also important and can
> be tuned based on perf/power requirements.
>
> Sharing my knowledge, hopefully it helps :)
>

Thanks. It was indeed helpful. :)

--
viresh
