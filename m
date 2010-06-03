Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0FCGux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:50:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0FCGut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:50:49 -0400
Message-ID: <4C07515D.9030505@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 14:53:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ben Dooks <ben-linux@fluff.org>, Nobin Mathew <nobin.mathew@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [TEMP PATCH v2] Re: make ARM=arm menuconfig problem in mainline
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com> <AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com> <20100602085748.6771e025.randy.dunlap@oracle.com> <AANLkTilpzeYVExQfLgpVmS3bPvb_h3kmWaatidekI-0r@mail.gmail.com> <4C068BAA.4030004@oracle.com> <20100603002526.GV4720@trinity.fluff.org> <4C07017A.50007@oracle.com>
In-Reply-To: <4C07017A.50007@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 06/02/10 17:25, Ben Dooks wrote:
>> On Wed, Jun 02, 2010 at 09:49:46AM -0700, Randy Dunlap wrote:
>>> On 06/02/10 09:08, Nobin Mathew wrote:
>>>> On Wed, Jun 2, 2010 at 9:27 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>>> On Wed, 2 Jun 2010 20:04:28 +0530 Nobin Mathew wrote:
>>>>>
>>>>>> adding linux-arm-kernel@lists.infradead.org
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> The following entry creates problem in ARM System type menu. I am
>>>>>> using a Fedora 12 system.
>>>>> What kind of problem does it create?
>>>>> It seems to work for me (on f11, not f12).
>>>>> Does it have something to do with F12 specifically?
>>>>>
>>>>>
>>>>>> Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
>>>>>> S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.
>>>>> Describe the problem, please.
>>> [please don't top-post]
>>
>> I can think of several solutions, the first being to remove the S3C prefix
>> friom all these.
>>
>> S3C24XX is not acceptable, there's S3C series that are either too old to
>> be bothered with, or don't fit under this architecture.
> 
> and not in the current kernel tree?
> I did not find any others in the current tree....
> 
>> how about Samsung S3C: 2410,2412/3,2416,2440/2442,2443,2450
> 
> OK, that works.
> 
> For kbuild/kconfig people:  run:
> make ARCH=arm O=test menuconfig
> 
> and then select System Type & ARM system type.  The kconfig "choice" menu at this
> point looks empty.  It seems to be just a text windowing/display problem.
> Pressing the down/up arrow keys will display the choices, although not where they
> should be displayed in the rectangle, and they can be selected there.
> 

I've found out the cause of this bug, and I'll cook up a patch soon. ;)

