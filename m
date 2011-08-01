Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1HAKfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:35:04 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:39821 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab1HAKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:34:57 -0400
Message-ID: <4E36813B.7090509@st.com>
Date: Mon, 1 Aug 2011 16:04:35 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 03/20] dmaengine/amba-pl08x: Rearrange inclusion of
 header files in ascending order
References: <cover.1312190881.git.viresh.kumar@st.com> <16f5abd9452832860f3a11fe1ddabde05fa3ae8c.1312190881.git.viresh.kumar@st.com> <4E367776.1070008@ru.mvista.com>
In-Reply-To: <4E367776.1070008@ru.mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 03:22 PM, Sergei Shtylyov wrote:
>> > +#include<linux/slab.h>
>     Shouldn't there be emoty line here?
> 
>> >   #include<asm/hardware/pl080.h>


Ya, can be, but i thought it is also fine. Don't know.
If you want i can do that.

-- 
viresh
