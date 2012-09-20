Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2ITPE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:04:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53912 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2ITPEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:04:25 -0400
From: "Bruce, Becky" <bbruce@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "snijsure@grid-net.com" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Thread-Topic: rcu self-detected stall messages on OMAP3, 4 boards
Thread-Index: AQHNlsN7frxYPZrEKkCUD0Qz+VBf1ZeTMQ2AgAAjvS4=
Date: Thu, 20 Sep 2012 15:03:57 +0000
Message-ID: <BF035652-91E8-4091-A883-8AB1773A7A17@ti.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com>
 <20120913011208.GT4257@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com>
 <20120920000351.GI2455@linux.vnet.ibm.com>,<alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll give it a try on my panda later today.

B

Sent from my iPhone

On Sep 20, 2012, at 2:56 AM, "Paul Walmsley" <paul@pwsan.com> wrote:

> Hi,
> 
> On Wed, 19 Sep 2012, Paul E. McKenney wrote:
> 
>> On Thu, Sep 13, 2012 at 06:52:10PM +0000, Paul Walmsley wrote:
>> 
>>> On Wed, 12 Sep 2012, Paul E. McKenney wrote:
>> 
>>>> Subodh Nijsure (also CCed) reported something that might be similar on
>>>> ARM, and also reported that setting the following got rid of the stalls:
>>>> 
>>>>    CONFIG_CPU_IDLE=y
>>>>    CONFIG_CPU_IDLE_GOV_LADDER=y
>>>>    CONFIG_CPU_IDLE_GOV_MENU=y
>>>> 
>>>> At which point he was happy, which was good, but which also left the
>>>> underlying problem unsolved.  Do these affect your system?  If so,
>>>> do they cause a different ARM idle loop to be executed?
>>> 
>>> Will give this a try.  What board was Subodh using?
>> 
>> Any news on trying the above settings?
> 
> Sorry, haven't had the chance to try it yet due to the impending merge 
> window opening.  Once things settle down I'll give it a try -- or maybe 
> someone else can test it in the meantime.
> 
> 
> - Paul
