Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1E0Ffv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:35:51 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54477 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab1E0Ffu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:35:50 -0400
Message-ID: <4DDF37DB.40606@st.com>
Date: Fri, 27 May 2011 11:04:19 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <21cnbao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Shiraz HASHIM'" <shiraz.hashim@st.com>,
        deepak sikri <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "'Rajeev KUMAR'" <rajeev-dlh.kumar@st.com>,
        "Vipin KUMAR (vipin.kumar@st.com)" <vipin.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>, Amit VIRDI <amit.virdi@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
References: <201105181047.17309.arnd@arndb.de>	<alpine.LFD.2.00.1105182234130.14430@xanadu.home>	<BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com> <201105191550.20129.arnd@arndb.de>
In-Reply-To: <201105191550.20129.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 07:20 PM, Arnd Bergmann wrote:
>> > i asked this because we wanted to send the source codes of
>> > CSR(http://www.csr.com) to upstream as i have told you in LDS. it
>> > looks like we need to follow the below new changes to make our source
>> > codes acceptable?
>> > 1. arm device tree
>> > 2. new pinmux framework from Linus Walleij
>> > 3. move GPIO from plat/mach to drivers/gpio?
> I would count at least the last two as mandatory, for the device tree,
> it depends on how much work it would be for you to do the conversion
> and at what time you submit the series. The longer you wait before
> submitting the series, the stricter the requirements will get.
> 

Arnd,

We also have few patchsets for ST's SPEAr SOC family. They were already
reviewed, but never got pushed.

We will update all those pacthsets for point 2 & 3, and leave point 1 for now.
Also we will update them with our latest changes for SPEAr and will circulate
them ASAP.

Hope that's fine.

-- 
viresh
