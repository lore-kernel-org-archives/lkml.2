Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1LMDek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:34:40 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:59246 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140Ab1LMDej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:34:39 -0500
Message-ID: <4EE6C7BA.30800@st.com>
Date: Tue, 13 Dec 2011 09:04:18 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
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
        Mirko GARDI <mirko.gardi@st.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 5/5] gpio/gpio-stmpe: ADD support for stmpe variant
 801
References: <cover.1321507421.git.viresh.kumar@st.com> <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com> <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com> <4EC9D175.2070008@st.com> <20111121145116.GA32137@sirena.org.uk> <4ECB1BA6.4050803@st.com> <20111212142058.GE13952@sortiz-mobl>
In-Reply-To: <20111212142058.GE13952@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 7:50 PM, Samuel Ortiz wrote:
> Ok, so I reverted your first 2 patches patchset since it seems it was
> problematic. Now, I think Rabin's concern on your patch #5 seems valid, and
> I'd like you to fix it before applying this patchset.

Which problem are you talking about? Issues in v2 of patch 5/5 or converting to regmap?

Earlier once are already fixed in V3 of 5/5. And for later one, i already confirmed to
do it in a separate patchset.

-- 
viresh
