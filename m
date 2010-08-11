Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0HKHD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:03:56 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:37502 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab0HKHDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:03:55 -0400
Message-ID: <4C624AE1.30504@st.com>
Date: Wed, 11 Aug 2010 12:31:53 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "git@vger.kernel.org" <git@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Valeo de Vries <valeo@valeo.co.cc>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>, <mihai.dontu@gmail.com>,
        <dwmw2@infradead.org>, <richardcochran@gmail.com>,
        "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>
In-Reply-To: <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2010 3:34 AM, Felipe Contreras wrote:
> On Mon, Aug 9, 2010 at 9:07 AM, viresh kumar <viresh.kumar@st.com> wrote:
>> > Mail server in ST has recently changed and now we have Microsoft
>> > exchange server. We are using thunderbird as mail client.
>> > What we observed with this server is that patch are broken now while
>> > sending as well as receiving. Tabs are replaced by spaces and may
>> > be some other too which we haven't observed.
>> >
>> > Has anybody found a solution to this kind of issues? Are there any
>> > workarounds possible?
> Same in Nokia. I wrote a script to fix exchange's crap, but I also
> noticed some quoted-printable mails didn't get converted, so the
> easiest would be to tell git to always send quoted-printable.
> 

Hi Guys

The situation has changed now.
We are informed that SP2 is already in place in ST and mail client is not
doing any tampering.

When i send a mail using git send-email then it receives fine on
outlook but on thunderbird, tabs are converted to spaces.

This doesn't happen with every patch on thunderbird, but only a few.
And observation is that it happens only with big patches.
(more than 500 lines)

Any idea, how to solve issue now on thunderbird??

viresh.
