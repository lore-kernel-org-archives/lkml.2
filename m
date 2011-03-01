Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1CAJN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:13:29 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:35348 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035Ab1CAJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:13:27 -0500
Message-ID: <4D6CB8A3.9080203@st.com>
Date: Tue, 1 Mar 2011 14:43:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] device.h: add device_set_platdata routine
References: <5c561db378360ad1763da41f8350c7be816daa06.1298953633.git.viresh.kumar@st.com> <20110301075953.GR22310@pengutronix.de> <4D6CADE5.6000206@st.com> <20110301090518.GV22310@pengutronix.de>
In-Reply-To: <20110301090518.GV22310@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 02:35 PM, Uwe Kleine-König wrote:
>> > Ok. So we should use platform_device_add_data instead and mark our platform
>> > data's struct as __init. So that it doesn't consume any memory after
>> > this routine is done??
> Yeah, either __initdata or still better const + __initconst if possible.

Ok. Thanks for your help.

-- 
viresh
