Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1G2Pa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:30:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1G2Paz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <1311941799.1536.532.camel@vkoul-udesk3>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
	<1311941799.1536.532.camel@vkoul-udesk3>
Date: Fri, 29 Jul 2011 08:30:54 -0700
Message-ID: <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com>
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case of
 error interrupt
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
>> +		dev_err(&pl08x->adev->dev, "%s error interrupt, register value"
>> +				"0x%08x\n", __func__, err);
> again this looks convoluted, and the stuff is quotes can be in single
> line :)

Will take care of this in all patches.

> but in tasklet you will call the client callback, so how does the client
> know if this was success or error? Did I miss anything?

No you didn't. I couldn't find a way in framework to report back to
client success or failure.
Is there any way? For now i have only kept error prints.

--
viresh
