Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1KREDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:03:17 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:40211 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032Ab1KREDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:03:16 -0500
Message-ID: <4EC5D8F0.3040905@st.com>
Date: Fri, 18 Nov 2011 09:32:56 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
Subject: Re: [PATCH] GPIO/pl061: Add suspend resume capability
References: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com> <201111172134.31591.rjw@sisk.pl>
In-Reply-To: <201111172134.31591.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 2:04 AM, Rafael J. Wysocki wrote:
>> > +static const struct dev_pm_ops pl061_dev_pm_ops = {
>> > +	.suspend = pl061_suspend,
>> > +	.resume = pl061_resume,
> Please also include hibernation callbacks here, otherwise your code will
> break systems with hibernation enabled.
> 
> There are convenience macros for that in linux/pm.h, please use one of them.

Sure. Thanx.

-- 
viresh
