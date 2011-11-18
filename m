Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1KRDaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:30:46 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:55064 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910Ab1KRDap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:30:45 -0500
Message-ID: <4EC5D14D.8080702@st.com>
Date: Fri, 18 Nov 2011 09:00:21 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
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
References: <6c6957c60969ac5df8bfe59a2502a4077284d2e1.1321528179.git.viresh.kumar@st.com> <20111117135433.GC3299@sapphire.tkos.co.il>
In-Reply-To: <20111117135433.GC3299@sapphire.tkos.co.il>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 7:24 PM, Baruch Siach wrote:
>> > +struct gpio_context_save_regs {
> Nit: I think pl061_context_save_regs is a better name.
> 

Sure.

> Other then that:
> 
> Acked-by: Baruch Siach <baruch@tkos.co.il>

Thanks.

-- 
viresh
