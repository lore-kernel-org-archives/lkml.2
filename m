Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1KVDtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:49:13 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:44181 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab1KVDtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:49:12 -0500
Message-ID: <4ECB1BA6.4050803@st.com>
Date: Tue, 22 Nov 2011 09:18:54 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Cc: Rabin Vincent <rabin@rab.in>, Linus WALLEIJ <linus.walleij@stericsson.com>,
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
References: <cover.1321507421.git.viresh.kumar@st.com> <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com> <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com> <4EC9D175.2070008@st.com> <20111121145116.GA32137@sirena.org.uk>
In-Reply-To: <20111121145116.GA32137@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 8:21 PM, Mark Brown wrote:
>> > I assumed stmpe_set_bits will only affect bits which are 1
>> > in mask and i was wrong. :(
> That does look like a straight bug in stmpe_set_bits() which ought to be
> fixed regardless of anything else.
> 

I think so. I will fix it in a separate patch.

>>> > >  (2) for other devices, adds an an unnecessary read (within stmpe_set_bits()),
>>> > >      which wasn't there before.
>> > Correct.
>>> > > Please rework to something like:
> Looking at the code in stmpe.c it might be as well to convert to regmap
> which would if nothing else save a bunch of custom code in the driver
> and let you use the cache code to eliminate the read.  Probably that
> will help eliminate reads in other places too.

Ya, i already got this feedback from Rabin. I am a bit busy right now and so
requested sameo to accept this patchset as it is. I will update drivers to use
regmap as soon as i get some time.

-- 
viresh
