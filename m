Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2CZLlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:41:23 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:38708 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390Ab2CZLlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:41:22 -0400
Message-ID: <4F705586.5020905@st.com>
Date: Mon, 26 Mar 2012 17:09:50 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Stefan Roese <sr@denx.de>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        spear-devel <spear-devel@list.st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] rtc/spear: Add Device Tree probing capability
References: <8747a4b3bdcfb7b3384c14ca909228e1164d0fc5.1332755275.git.viresh.kumar@st.com> <201203261332.02073.sr@denx.de>
In-Reply-To: <201203261332.02073.sr@denx.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2012 5:02 PM, Stefan Roese wrote:
>> > +	rtc@fc000000 {
>> > +		compatible = "st,spear-rtc";
> With Rob's comments in mind, wouldn't it be better to use a more specific 
> compatible property? Should we stick with "st,spear600-rtc"? Or use "st-
> spear300-rtc" as "oldest" SoC variant?

Can name it spear600-rtc then.

-- 
viresh
