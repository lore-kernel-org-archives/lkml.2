Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1GaAkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:40:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34064 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1GaAkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<2f6001455c4e54f56716a245c7e319eb25a9bb0d.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:40:36 +0200
X-Google-Sender-Auth: glbsUC22lvOoitzzwEr24JoM1ZU
Message-ID: <CAKnu2MqrKxPDzCUtTVH8DrBR2JqcsyFpr-9ppS1=iR3uAPs2Og@mail.gmail.com>
Subject: Re: [PATCH 15/18] dmaengine/amba-pl08x: Pass flow controller
 information with slave channel data
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

I have the same comment as Russell basically:

> @@ -65,6 +69,7 @@ struct pl08x_channel_data {
>        int max_signal;
>        u32 muxval;
>        u32 cctl;
> +       u32 fc;

bool device_fc;

or similar. Then encode the necessary bits if the device controls
flow, and fall back to default (DMAC control) otherwise.

>        dma_addr_t addr;
>        bool circular_buffer;
>        bool single;
> --
> 1.7.2.2

Thanks,
Linus Walleij
