Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1F2Jfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:35:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50754 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1F2Jfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110629091441.GA9349@pengutronix.de>
References: <cover.1306831238.git.viresh.kumar@st.com>
	<201106271526.12848.arnd@arndb.de>
	<20110628100438.GI6069@pengutronix.de>
	<201106281713.16099.arnd@arndb.de>
	<20110629091441.GA9349@pengutronix.de>
Date: Wed, 29 Jun 2011 15:05:28 +0530
Message-ID: <BANLkTik67AoaUMTTGnOuB27Rg55zU-qf=w@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
From: viresh kumar <viresh.linux@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Viresh KUMAR <viresh.kumar@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 2:44 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Jun 28, 2011 at 05:13:15PM +0200, Arnd Bergmann wrote:
>> On Tuesday 28 June 2011, Sascha Hauer wrote:
>
> Definitely. From a quick look at the driver it seems the pwms all have
> a seperate register space.
>

Actually, latest version of pwm (not present in current patch) has
common registers to all pwm devices.

> I can add Viresh's patch to my series once we agree on the base patch.
> In the meantime maybe Viresh starts converting it ;)

I will not be able to do this now due to some other activities i am
doing currently. :(
May be you can go ahead with your patchset and i will update mine and
send it back as soon as i get some time.

--
viresh
