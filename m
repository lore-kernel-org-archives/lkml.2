Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0JKOnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:43:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56161 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0JKOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:43:51 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "l-o" <linux-omap@vger.kernel.org>,
        "l-a" <linux-arm-kernel@lists.infradead.org>,
        Paul <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v7] power: introduce library for device-specific OPPs
Organization: Deep Root Systems, LLC
References: <1286506969-20651-1-git-send-email-nm@ti.com>
	<201010100059.20964.rjw@sisk.pl>
Date: Mon, 11 Oct 2010 07:43:45 -0700
In-Reply-To: <201010100059.20964.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 10 Oct 2010 00:59:20 +0200")
Message-ID: <878w24u6vy.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, October 08, 2010, Nishanth Menon wrote:
>> SoCs have a standard set of tuples consisting of frequency and
>> voltage pairs that the device will support per voltage domain. These
>> are called Operating Performance Points or OPPs. The actual
>> definitions of OPP varies over silicon versions. For a specific domain,
>> we can have a set of {frequency, voltage} pairs. As the kernel boots
>> and more information is available, a default set of these are activated
>> based on the precise nature of device. Further on operation, based on
>> conditions prevailing in the system (such as temperature), some OPP
>> availability may be temporarily controlled by the SoC frameworks.
>> 
>> To implement an OPP, some sort of power management support is necessary
>> hence this library depends on CONFIG_PM.
>> 
>> Contributions include:
>> Sanjeev Premi for the initial concept:
>> 	http://patchwork.kernel.org/patch/50998/
>> Kevin Hilman for converting original design to device-based
>> Kevin Hilman and Paul Walmsey for cleaning up many of the function
>> abstractions, improvements and data structure handling
>> Romit Dasgupta for using enums instead of opp pointers
>> Thara Gopinath, Eduardo Valentin and Vishwanath BS for fixes and
>> cleanups.
>> Linus Walleij for recommending this layer be made generic for usage
>> in other architectures beyond OMAP and ARM.
>> Mark Brown, Andrew Morton, Rafael J Wysocki, Paul E McKenney for valuable
>> improvements.
>> 
>> Discussions and comments from:
>> http://marc.info/?l=linux-omap&m=126033945313269&w=2
>> http://marc.info/?l=linux-omap&m=125482970102327&w=2
>> http://marc.info/?t=125809247500002&r=1&w=2
>> http://marc.info/?l=linux-omap&m=126025973426007&w=2
>> http://marc.info/?t=128152609200064&r=1&w=2
>> http://marc.info/?t=128468723000002&r=1&w=2
>> incorporated.
>> 
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Madhusudhan Chikkature Rajashekar <madhu.cr@ti.com>
>> Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
>> Cc: Roberto Granados Dorado <x0095451@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>
>> Cc: Tero Kristo <Tero.Kristo@nokia.com>
>> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Sanjeev Premi <premi@ti.com>
>> Cc: Thara Gopinath <thara@ti.com>
>> Cc: Vishwanath BS <vishwanath.bs@ti.com>
>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> 
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>
> OK
>
> Your error messages are a bit inconsistent (e.g. some of them print the
> error code while others don't), but I guess I can fix that up.
>
> Still, to apply the patch I need a copyright notice for the doc too.
>
>> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>
> Kevin, your sign-off here means you endorse the patch as the maintainer.
> Is that correct?

Correct.

Thanks,

Kevin
