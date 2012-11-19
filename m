Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2KSINT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:13:19 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:32969 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KSINR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:13:17 -0500
Message-ID: <50A9EA11.7050409@free-electrons.com>
Date: Mon, 19 Nov 2012 09:13:05 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>
Subject: Re: [PATCH V3 4/5] arm: mm: Added support for PJ4B cpu and init routines
References: <1352931637-3405-1-git-send-email-gregory.clement@free-electrons.com> <1352931637-3405-5-git-send-email-gregory.clement@free-electrons.com> <50A41BD3.9040509@free-electrons.com> <50A6B427.9080807@free-electrons.com> <20121119031210.GD22106@titan.lakedaemon.net>
In-Reply-To: <20121119031210.GD22106@titan.lakedaemon.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 04:12 AM, Jason Cooper wrote:
> On Fri, Nov 16, 2012 at 10:46:15PM +0100, Gregory CLEMENT wrote:
>> On 11/14/2012 11:31 PM, Gregory CLEMENT wrote:
>>> Hello Russell,
>>>
>>> With the 2 changes I have done on according your comments
>>> do you think you can give your acked-by for this patch?
>>>
>>
>> Hello Russell,
>>
>> I didn't have any feedback from you for this version.
>> If you are fine with this, could you give your Acked-by?
>>
>>
> 
> Gregory,
> 
> From the looks of things, Russell has his head wrapped around buggy
> sound driver code for the CuBox.  Perhaps Will Deacon or Catalin Marinas
> would care to weigh in?  I'm reluctant to take the series without an
> Acked-By from at least one of them.


I am fine with this as Will already have done the review.

Arnd, Olof,
Do you agree to get the pull from Jason with an acked-by from
Will and/or Catalin instead of Russell?


Catalin, Will,
If Arnd and Olof agree, would you mind give your acked-by on this
pacth?

Russell,
if you had a couple of minutes, the best would be to have your acked-by
of course.

Thanks all,

Gregory
