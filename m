Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1CGPin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:38:43 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:19586
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab1CGPim convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:38:42 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz542N1432N4015L9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>
Subject: RE: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Topic: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Index: AQHL23Z02wru9FbG9kebNQISz1Arp5QiA6BA
Date: Mon, 7 Mar 2011 15:37:38 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
	<56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
 <87oc5puwg3.fsf@lebrac.rtp-net.org>
In-Reply-To: <87oc5puwg3.fsf@lebrac.rtp-net.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.68.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

Just to verify that you are testing on an MX51-Babbage board? Here's my log:

root@freescale ~$ uname -a
Linux freescale 2.6.38-rc1+ #93 Fri Mar 4 17:18:15 CST 2011 armv7l GNU/Linux
root@freescale ~$ echo mem > /sys/power/state
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)

<Press power key here, and the wake up is the bottom>.

PM: suspend of devices complete after 0.835 msecs
PM: suspend devices took 0.000 seconds
PM: late suspend of devices complete after 0.159 msecs
PM: early resume of devices complete after 0.187 msecs
PM: resume of devices complete after 81.911 msecs
PM: resume devices took 0.090 seconds
Restarting tasks ... done.
root@freescale ~$


Thanks,

Dinh

>-----Original Message-----
>From: Arnaud Patard [mailto:arnaud.patard@rtp-net.org]
>Sent: Saturday, March 05, 2011 2:47 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
>s.hauer@pengutronix.de; u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; Vaidyanathan Ranjani-RA5478
>Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
>
>Nguyen Dinh-R00091 <R00091@freescale.com> writes:
>
>> Hi Arnaud,
>
>Hi,
>
>>
>> I just sent out a 2nd set of the MX51 LPM patch. I have tested successfully on my mx51 babbage
>without any code modifications.
>>
>> If you would kindly verify on your side, that would great.
>>
>> You need both patches:
>>
>> [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
>> [PATCHv2 2/2] ARM: mx51: Add support for low power suspend on MX51
>
>No success. I even tried disabling nearly all drivers and nothing. The
>last line I have in the serial console is :
>
>PM: late suspend of devices complete after 0.354 msecs
>
>So, I still don't know if the system is crashing while suspending or if
>the system is suspended but doesn't wake up.
>
>Arnaud


