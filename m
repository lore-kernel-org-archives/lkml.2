Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1HEQDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:03:15 -0400
Received: from smtp3.Stanford.EDU ([171.67.219.83]:46089 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756532Ab1HEQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:03:11 -0400
Message-ID: <4E3C1437.7030301@ccrma.stanford.edu>
Date: Fri, 05 Aug 2011 09:03:03 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0-rt6
References: <alpine.LFD.2.02.1107282213000.31246@ionos> <4E3A3D7C.6050403@localhost> <1312450965.16729.7.camel@twins> <4E3AED68.5060506@ccrma.stanford.edu> <20110804201500.GL31521@pengutronix.de> <20110805092845.GP31521@pengutronix.de>
In-Reply-To: <20110805092845.GP31521@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 02:28 AM, Uwe Kleine-König wrote:
> On Thu, Aug 04, 2011 at 10:15:00PM +0200, Uwe Kleine-König wrote:
>> On Thu, Aug 04, 2011 at 12:05:12PM -0700, Fernando Lopez-Lezcano wrote:
>>> Was going to try this but it appears it is in rt7, trying to build
>>> rt7 fails with:
>>>
>>> ERROR: "of_find_property" [drivers/tty/serial/of_serial.ko] undefined!
>>> ERROR: "of_find_property" [drivers/hwmon/ltc4245.ko] undefined!
>> This is known but unfixed, see
>> http://mid.gmane.org/20110722065711.GD16561@pengutronix.de
>>
>> You should be able to workaround that by jugling with the .config. I.e.
>> disable OF or something like that.
> Can you send me a .config, then I'd look into that.

To work around the issue I had to disable:

   CONFIG_SERIAL_OF_PLATFORM
   CONFIG_SENSORS_LTC4245

-- Fernando
