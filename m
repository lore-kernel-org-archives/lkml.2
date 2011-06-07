Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1FGIg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:36:29 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:55055 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab1FGIg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:36:27 -0400
Message-ID: <4DEDE2D7.6030100@st.com>
Date: Tue, 7 Jun 2011 14:05:35 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] gpio/spear-plgpio: Add plgpio driver for SPEAr platform
References: <cover.1306737135.git.viresh.kumar@st.com> <385c65f02831af2a16bcd4ea56c22ce6d8747ef0.1306737135.git.viresh.kumar@st.com> <20110603175020.GD15616@ponder.secretlab.ca>
In-Reply-To: <20110603175020.GD15616@ponder.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 11:20 PM, Grant Likely wrote:
> On Mon, May 30, 2011 at 12:09:02PM +0530, Viresh Kumar wrote:
>> > Plgpio pads on few spear machines can be configured as gpios. This patch adds
>> > support for configuring these PLGPIOs.
>> >
>> > This was earlier posted & reviewed as part of arch/arm/plat-spear/ code.
>> >
>> > Reviewed-by: Stanley Miao <stanley.miao@windriver.com>
>> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> 
> This ends up being yet-another-mmio-gpio implementation.  Please look
> at bgpio_init() in drivers/basic_mmio_gpio.c.  This driver should be
> refactored to use that.

Ok. Will check that.

-- 
viresh
