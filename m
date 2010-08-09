Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0HIHsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:48:09 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:55899 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548Ab0HIHsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:48:07 -0400
Message-ID: <4C5FB2AC.40605@st.com>
Date: Mon, 9 Aug 2010 13:17:56 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.1
MIME-Version: 1.0
To: Valeo de Vries <valeo@valeo.co.cc>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com>	<20100809064957.GB16661@pengutronix.de>	<4C5FA698.90904@st.com> <AANLkTi=qj2gM-c=P+5MQTB=ScR4J6GPW70RoQHr4H748@mail.gmail.com>
In-Reply-To: <AANLkTi=qj2gM-c=P+5MQTB=ScR4J6GPW70RoQHr4H748@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2010 12:49 PM, Valeo de Vries wrote:
> 2010/8/9 viresh kumar <viresh.kumar@st.com>:
>> > On 8/9/2010 12:19 PM, Uwe Kleine-König wrote:
>>> >> Hello,
>>> >>
>>> >> On Mon, Aug 09, 2010 at 11:37:33AM +0530, viresh kumar wrote:
>>>>> >>> > Hello,
>>>>> >>> >
>>>>> >>> > Mail server in ST has recently changed and now we have Microsoft
>>>>> >>> > exchange server. We are using thunderbird as mail client.
>>>>> >>> > What we observed with this server is that patch are broken now while
>>>>> >>> > sending as well as receiving. Tabs are replaced by spaces and may
>>>>> >>> > be some other too which we haven't observed.
>>> >> unlucky you.
>>> >>
>>>>> >>> > Has anybody found a solution to this kind of issues? Are there any
>>>>> >>> > workarounds possible?
>>> >> git.git has some tips for thunderbird, see
>>> >>
>>> >>       http://git.kernel.org/?p=git/git.git;a=blob;f=Documentation/SubmittingPatches;hb=HEAD
>>> >>
>>> >> and look for the section titled "Thunderbird" (small surprise).
>> >
>> > I missed this information in my last mail. We are using git send-email for
>> > sending patches. As patches will go through Microsoft exchange server only,
>> > so they are broken.
>> >
>> > With previous server everything was working fine.
> You might want to take a look at
> http://bombadil.infradead.org/~mcgrof/MS-exchange-sucks-for-patches/
> for a possible explanation. Long story short: upgrade Exchange, or use
> a different SMTP server that doesn't try to be smarter than its users
> (or should that be an SMTP server that isn't just plain
> arse-backwards?).

Valeo,

Thanks for this. It really helped us.

viresh.
