Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1JRJHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:07:33 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58786 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880Ab1JRJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:07:31 -0400
Message-ID: <4E9D417E.1020203@st.com>
Date: Tue, 18 Oct 2011 14:36:06 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>  <1318570705-17595-3-git-send-email-vinod.koul@intel.com>  <4E9BBCEB.9090204@st.com> <1318857324.23438.96.camel@vkoul-udesk3>
In-Reply-To: <1318857324.23438.96.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 6:45 PM, Vinod Koul wrote:
>> > Can you please add something in the commit message, to explain why is
>> > it done.
> I think 01/10 explains it well

Ok. I wasn't in cc of that patch, so couldn't link it. But still
i think every patch should have some sort of explanation or link to another patch
that explains why is it done. Isn't it?

-- 
viresh
