Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1DYCNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:13:21 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:34777 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758011Ab1DYCNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:13:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-Identified-User;
	b=ksCUXDG5q07C1vt3ED+c17RfLLXYCmOJBMbdbq/HLW5LAN4hYlY38m5iHfPfWsqfy/+5zq9sOCa8GHwUPLl0J3JQWs2qmbE/ngIW+08LmybXRs9pyx5L+j4AW5T37YHu;
Message-ID: <4ac1d916ddc0ab9e7e94b81bc77880be.squirrel@xenotime.net>
In-Reply-To: <BANLkTikWa7wZYonWLHMqWkBRHfi7tLiyuA@mail.gmail.com>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
    <20110421085124.4a44d048.randy.dunlap@oracle.com>
    <BANLkTinoi1SeuuPj5SeTzssyBTvTQu6pMA@mail.gmail.com>
    <4DB2F406.404@oracle.com>
    <BANLkTikWa7wZYonWLHMqWkBRHfi7tLiyuA@mail.gmail.com>
Date: Sun, 24 Apr 2011 19:13:16 -0700
Subject: Re: linux-next: Tree for April 21 (i82975x_edac)
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Arvind R" <arvino55@gmail.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "Ranganathan Desikan" <ravi@jetztechnologies.com>,
        linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org,
        "Doug Thompson" <dougthompson@xmission.com>,
        "Jason Uhlenkott" <juhlenko@akamai.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, April 23, 2011 11:29 pm, Arvind R wrote:
> On Sat, Apr 23, 2011 at 9:15 PM, Randy Dunlap <randy.dunlap@oracle.com>
> wrote:
>> On 04/23/11 01:21, Arvind R wrote:
>>> On Thu, Apr 21, 2011 at 9:21 PM, Randy Dunlap <randy.dunlap@oracle.com>
>>> wrote:
>>>> On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:
>>>>
>>>>> Changes since 20110420:
>>>>
>>>>
>>>> on i386:
>>>>
>>>> drivers/edac/i82975x_edac.c:298: warning: integer constant is too
>>>> large for 'unsigned long' type
>
>> I think that the goal should be to get your 4-patch series merged.
>>
>>> That would still not fix the wrong error-info reported by the driver -
>>> this is
>>> fixed by the patch-set titled '[RFC PATCH 2.6.37 0/4] i3000_edac :
>>> merge
>>> i82975x support' dated 2011-02-14 in the linux-edac archives.
>>>
>>> Please advise on getting the patch into main-stream. The I3000 is a
>>> re-labeled
>>> i82975x (or vice-versa). Hence the patch-set to merge the drivers. If
>>> separate
>>> i82975x driver is needed - I can provide the patch. The reported bug is
>>> not
>>> present in the merge-patched driver.
>>
>> Doug, any plans to merge this 4-patch series from Arvind?
>>
>> Arvind, was bluesmoke-devel@lists.sourceforge.net copied on this patch
>> series?
> No - thought that the bluesmoke-list had moved to linux-edac.
>

If bluesmoke-devel is obsolete, the MAINTAINERS file
needs to be updated.

>>
>> and was the I3000 driver maintainer copied?  (added)
>> I can't tell this from the marc.info archives.
> Added myself to the driver maintainer in the i3000_edac.c file. The
> patch-set adds support for i82975x in the i3000 driver, which is
> better structured.
> TODO:
>     1. Change Kconfig file - select I3000 for i82975x support
>     2. Delete i82975x_edac.c file
>     3. Update MAINTAINERS file

Did the other EDAC-I3000 maintainer respond?

thanks,
-- 
~Randy

