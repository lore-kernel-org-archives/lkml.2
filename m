Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1GaFvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:51:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35209 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1GaFvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MpzFK1HHhs7F5PV1EsbCG9y1Htbu5KM7x0OC2_9U=vovA@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com>
	<1311941355.1536.529.camel@vkoul-udesk3>
	<CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
	<CAKnu2MrWbm5w6QsBzj=Fd=f7SfE=4_7bHMBBdQiN2bCnbeV-eg@mail.gmail.com>
	<20110730225708.GB17570@n2100.arm.linux.org.uk>
	<CAKnu2MpzFK1HHhs7F5PV1EsbCG9y1Htbu5KM7x0OC2_9U=vovA@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:51:38 -0700
Message-ID: <CAOh2x=nMK+fFUHd_JTFZg8HwFGKi+FbpzP-o94hcNa64Hj47bA@mail.gmail.com>
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment and
 rewrite original
From: viresh kumar <viresh.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        "Koul, Vinod" <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        vipin.kumar@st.com, armando.visconti@st.com, amit.virdi@st.com,
        vipulkumar.samar@st.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/11, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/7/31 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> On Sun, Jul 31, 2011 at 12:32:55AM +0200, Linus Walleij wrote:
>>> The PL08x has two bus mastering interfaces. They can be
>>> connected to two separate busses and two adress spaces
>>> even, usually that is not the case though.
>>
>> This is not what the function is about... that's done by my
>> pl08x_select_bus() function.
>
> To be clear, I was explaining what I percieved as a
> question from Viresh about what the comment in this hunk of
> the patch was about:
>

Just to clear my question again:
- It wasn't about the comment but concept behind Master/Slave terminology.
- Why are we referring src and dest as Master and Slave. As there is
nothing like that.
- As pointed by Russell and me earlier: Probably it is for choosing
the victim for
reduction of width, in case src and dest addresses are misaligned to each other.

If what i understood is correct, then we should get rid of this
routine or this master/slave
terminology, as this is causing confusion.

--
viresh
