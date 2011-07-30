Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1G3W5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:57:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59024 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1G3W5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:57:33 -0400
Date: Sat, 30 Jul 2011 23:57:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: viresh kumar <viresh.linux@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        armando.visconti@st.com, linux-kernel@vger.kernel.org,
        vipin.kumar@st.com, shiraz.hashim@st.com, amit.virdi@st.com,
        vipulkumar.samar@st.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment
	and rewrite original
Message-ID: <20110730225708.GB17570@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com> <1311941355.1536.529.camel@vkoul-udesk3> <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com> <CAKnu2MrWbm5w6QsBzj=Fd=f7SfE=4_7bHMBBdQiN2bCnbeV-eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKnu2MrWbm5w6QsBzj=Fd=f7SfE=4_7bHMBBdQiN2bCnbeV-eg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 12:32:55AM +0200, Linus Walleij wrote:
> 2011/7/29 viresh kumar <viresh.linux@gmail.com>:
> > Nor mine either. :)
> >
> > Will give some more explanation.
> >
> > But before that i wanted to know the exact purpose of this
> > master-slave concept here.
> 
> The PL08x has two bus mastering interfaces. They can be
> connected to two separate busses and two adress spaces
> even, usually that is not the case though.

This is not what the function is about... that's done by my
pl08x_select_bus() function.

This function (pl08x_choose_master_bus) does something completely
different, and has to do with how the LLIs are laid out.  I think
it's to do with whether we use the source or destination for
alignment purposes.

It really has nothing to do with choosing busses.
