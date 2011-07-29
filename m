Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1G2PkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:40:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52185 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1G2PkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <1311941980.1536.534.camel@vkoul-udesk3>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
	<1311941980.1536.534.camel@vkoul-udesk3>
Date: Fri, 29 Jul 2011 08:40:00 -0700
Message-ID: <CAOh2x==6m_UgWN=qour+0P1R7FrKvPHXy9Mu51U36br7vKHKUQ@mail.gmail.com>
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
From: viresh kumar <viresh.linux@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        pratyush.anand@st.com, rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk,
        bhupesh.sharma@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
>> You can still issue bursts within the PL080 that are in excess o f 1KB.
>> The
> 								^^^^^^
> of

Ok.
