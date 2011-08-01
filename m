Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HAX6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:58:11 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:58472
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab1HAX6G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:58:06 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h)
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
Thread-Index: AQHMUJTQaH7yU/veBU63U1YHEq4M5pUI/TKAgAADJQA=
Date: Mon, 1 Aug 2011 23:58:00 +0000
Message-ID: <4E373D88.80006@freescale.com>
References: <1312235334-15036-1-git-send-email-timur@freescale.com>
 <20110801234645.GA15792@sirena.org.uk>
In-Reply-To: <20110801234645.GA15792@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0)
 Gecko/20110706 Firefox/5.0 SeaMonkey/2.2
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <566B85BBB232B54D9F8DDE69A3AC0D29@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Aug 01, 2011 at 04:48:54PM -0500, Timur Tabi wrote:
>> The Data Collection Manager (DCM) is a feature of the FPGA on some Freescale
>> PowerPC reference boards that can read temperature, current, and voltage
>> settings from the sensors on those boards.  This driver exposes the DCM via a
>> sysfs interface (/sys/devices/platform/fsl-ocm.0).
>
> This sounds like it should be a hwmon driver.

I didn't see any way to interface the hardware to the hwmon layer in a 
manner that provides the information that our customers went using this 
hardware.

>> The DCM collects and tallies data over a period of time in the background,
>> without utilizing any resources on the host (CPU, memory, etc).  The data is
>> summarized and made available when data collection stops.  This allows power
>> consumption to be measured while the host is performing some tasks (usually
>> a benchmark).
>
> Though this is a bit odd for the subsystem I don't think it's too far
> out of what other hwmon chips can do, some of them do have longer term
> stats than just instantaneous readings.

Can you show an example or some documentation?  I couldn't find anything 
remotely like that.  I don't even see anything that lets me start/stop 
monitoring of sensors.

-- 
Timur Tabi
Linux kernel developer at Freescale
