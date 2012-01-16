Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2APKwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:52:54 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:34084 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab2APKwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:52:53 -0500
Message-ID: <4F14016A.4090209@st.com>
Date: Mon, 16 Jan 2012 16:22:26 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Subject: Re: [PATCH 5/8] dmaengine/dw_dmac: Use platform_get_drvdata instead
 of accessing dev directly
References: <cover.1326707233.git.viresh.kumar@st.com> <51d3263224d48c1d68de1449af28fb1570900254.1326707233.git.viresh.kumar@st.com> <4F14004F.2010906@ru.mvista.com>
In-Reply-To: <4F14004F.2010906@ru.mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2012 4:17 PM, Sergei Shtylyov wrote:
>> > Use already defined function platform_get_drvdata() instead of accessing
>> > pdev->dev.data.
>     pdev->dev.platform_data.
> 

Oops!! Will fix comment once i get comments over other patches too.

-- 
viresh
