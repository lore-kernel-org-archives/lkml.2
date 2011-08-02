Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1HBB5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:57:52 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:12785
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753514Ab1HBB5t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:57:49 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/misc: introduce Freescale Data Collection
 Manager driver
Thread-Topic: [PATCH] drivers/misc: introduce Freescale Data Collection
 Manager driver
Thread-Index: AQHMUJTQaH7yU/veBU63U1YHEq4M5pUI/TKAgAADJQCAAB+KgIAAAeoA
Date: Tue, 2 Aug 2011 01:57:45 +0000
Message-ID: <4E375998.1020901@freescale.com>
References: <1312235334-15036-1-git-send-email-timur@freescale.com>
 <20110801234645.GA15792@sirena.org.uk> <4E373D88.80006@freescale.com>
 <20110802015050.GA17286@opensource.wolfsonmicro.com>
In-Reply-To: <20110802015050.GA17286@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0)
 Gecko/20110706 Firefox/5.0 SeaMonkey/2.2
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <E482168DC516654B86C6FCF367175A39@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> I'd expect that things like the _lowest, _highest and _average
> attributes which a number of drivers have are what you're looking for.

Yes, but then all I'm doing is presenting numbers that don't change to an 
interface, simply on the basis that the numbers represent sensor values.

If I'm running a sensor application, I'm doing it to get real-time 
monitoring of the sensors in my system.  The DCM on our boards is not 
capable of real-time results.  So you're not actually "monitoring" the 
hardware.  The data from the DCM is available only *after* you stop 
running the background process.

> At the very least it seems obvious how you might extend the interface if
> some features you need are missing.  The subsystem has fairly extensive
> documentation in Documentation/hwmon.

I just don't see how it fits.  Yes, I could do it, but then I'd end up 
with something that doesn't make any sense.  I would have to use a custom 
interface to start monitoring and then another interface to stop it.  Then 
I would query the results use the hwmon interface, but the results would 
be static.  That just seems silly.

-- 
Timur Tabi
Linux kernel developer at Freescale
