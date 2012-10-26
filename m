Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab2JZPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:06:55 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:48236 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:06:54 -0400
Message-ID: <508AA6F5.7050806@free-electrons.com>
Date: Fri, 26 Oct 2012 17:06:29 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/4] arm: mvebu: adding SATA support: dt binding for
 Armada 370/XP
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com> <1351254650-26861-3-git-send-email-gregory.clement@free-electrons.com> <20121026133154.GN18811@titan.lakedaemon.net> <20121026133446.GM21046@lunn.ch> <508A945C.4010006@free-electrons.com> <20121026135225.GO21046@lunn.ch> <20121026165759.01df4489@skate> <20121026150206.GQ18811@titan.lakedaemon.net>
In-Reply-To: <20121026150206.GQ18811@titan.lakedaemon.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 05:02 PM, Jason Cooper wrote:
> On Fri, Oct 26, 2012 at 04:57:59PM +0200, Thomas Petazzoni wrote:
>>
>> On Fri, 26 Oct 2012 15:52:25 +0200, Andrew Lunn wrote:
>>>> Now, about white spaces vs tab, I don't know what is the rule
>>>> for .dts file.
>>>
>>> I personally use tabs, but i don't see anything in the
>>> Documentation/CodingStyle.
>>>
>>> Maybe ask on the device tree mailing list?
>>
>> Yes, it would be good to know and document what is the rule for .dts
>> files, and possibly extend checkpatch to cover those special rules
>> for .dts files.
> 
> until that is resolved, can we make this patch conform to what is in the
> file currently?  Once the dt folks clarify, we can run through all the
> dts's and submit one cleanup series.
> 
> If there are no other comments on this series, I'm fine taking it as is
> and doing the fixup on my end.  No need to do a version bump just for
> this.

OK then you will just have to replace my tabs by whitespace.

Thanks,

Gregory
