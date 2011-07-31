Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1GaJGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 05:06:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59591 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1GaJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 05:06:40 -0400
Date: Sun, 31 Jul 2011 10:06:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        shiraz.hashim@st.com, "Koul, Vinod" <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh kumar <viresh.linux@gmail.com>, deepak.sikri@st.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment
	and rewrite original
Message-ID: <20110731090619.GA30888@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com> <1311941355.1536.529.camel@vkoul-udesk3> <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com> <CAKnu2MrWbm5w6QsBzj=Fd=f7SfE=4_7bHMBBdQiN2bCnbeV-eg@mail.gmail.com> <20110730225708.GB17570@n2100.arm.linux.org.uk> <CAKnu2MpzFK1HHhs7F5PV1EsbCG9y1Htbu5KM7x0OC2_9U=vovA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKnu2MpzFK1HHhs7F5PV1EsbCG9y1Htbu5KM7x0OC2_9U=vovA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 01:37:46AM +0200, Linus Walleij wrote:
> 2011/7/31 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Sun, Jul 31, 2011 at 12:32:55AM +0200, Linus Walleij wrote:
> >> The PL08x has two bus mastering interfaces. They can be
> >> connected to two separate busses and two adress spaces
> >> even, usually that is not the case though.
> >
> > This is not what the function is about... that's done by my
> > pl08x_select_bus() function.
> 
> To be clear, I was explaining what I percieved as a
> question from Viresh about what the comment in this hunk of
> the patch was about:

Yes, and the comment and function name are wrong for what it's doing.
I repeat: it has nothing to do with selecting an AHB bus.

> As for the LLI code, all of it's weird complexity comes from the fact
> that the DMAC cannot let a single element pass across 1KB (0x400)
> boundaries, which is one more than a little insane hardware
> restriction, and I have no clue where that limitation actually comes
> from, likely strange VHDL code.

Viresh's discussion with ARM Ltd indicates that this is not the case,
and that restriction comes from misunderstanding of the documentation.
