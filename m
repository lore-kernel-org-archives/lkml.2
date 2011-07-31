Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1GaFg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:36:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1GaFgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MqrKxPDzCUtTVH8DrBR2JqcsyFpr-9ppS1=iR3uAPs2Og@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
	<CAKnu2MqrKxPDzCUtTVH8DrBR2JqcsyFpr-9ppS1=iR3uAPs2Og@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:36:48 -0700
Message-ID: <CAOh2x=n1FWvDX9n7RJwQJjm3+mnWJe5kAYdOg0nZ2D7BVt4nmg@mail.gmail.com>
Subject: Re: [PATCH 15/18] dmaengine/amba-pl08x: Pass flow controller
 information with slave channel data
From: viresh kumar <viresh.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/11, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/7/29 Viresh Kumar <viresh.kumar@st.com>:
>
> I have the same comment as Russell basically:
>
>> @@ -65,6 +69,7 @@ struct pl08x_channel_data {
>>        int max_signal;
>>        u32 muxval;
>>        u32 cctl;
>> +       u32 fc;
>
> bool device_fc;
>
> or similar. Then encode the necessary bits if the device controls
> flow, and fall back to default (DMAC control) otherwise.
>

Yes. I thought of exactly the same code.

--
viresh
