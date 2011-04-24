Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1DXG3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:29:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1DXG3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sEg1lZqzHPJfEAb+TIMsmi0qy87D9rO///ITxAoHTRe4Wc1aZcVMtuon4yhPRTDQqc
         g9JkjzPyM+CS+vhosanYy4ojfIgkpJiN/UsPxKgYq/0/6dDLmOMg5u5rRwvwfOcpqlOq
         FKIJmFWn3qh1MB6Gn4kiY08j698w49RY55g8Q=
MIME-Version: 1.0
In-Reply-To: <4DB2F406.404@oracle.com>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
	<20110421085124.4a44d048.randy.dunlap@oracle.com>
	<BANLkTinoi1SeuuPj5SeTzssyBTvTQu6pMA@mail.gmail.com>
	<4DB2F406.404@oracle.com>
Date: Sun, 24 Apr 2011 11:59:40 +0530
Message-ID: <BANLkTikWa7wZYonWLHMqWkBRHfi7tLiyuA@mail.gmail.com>
Subject: Re: linux-next: Tree for April 21 (i82975x_edac)
From: Arvind R <arvino55@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Jason Uhlenkott <juhlenko@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 9:15 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 04/23/11 01:21, Arvind R wrote:
>> On Thu, Apr 21, 2011 at 9:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:
>>>
>>>> Changes since 20110420:
>>>
>>>
>>> on i386:
>>>
>>> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for 'unsigned long' type

> I think that the goal should be to get your 4-patch series merged.
>
>> That would still not fix the wrong error-info reported by the driver - this is
>> fixed by the patch-set titled '[RFC PATCH 2.6.37 0/4] i3000_edac : merge
>> i82975x support' dated 2011-02-14 in the linux-edac archives.
>>
>> Please advise on getting the patch into main-stream. The I3000 is a re-labeled
>> i82975x (or vice-versa). Hence the patch-set to merge the drivers. If separate
>> i82975x driver is needed - I can provide the patch. The reported bug is not
>> present in the merge-patched driver.
>
> Doug, any plans to merge this 4-patch series from Arvind?
>
> Arvind, was bluesmoke-devel@lists.sourceforge.net copied on this patch series?
No - thought that the bluesmoke-list had moved to linux-edac.

>
> and was the I3000 driver maintainer copied?  (added)
> I can't tell this from the marc.info archives.
Added myself to the driver maintainer in the i3000_edac.c file. The
patch-set adds support for i82975x in the i3000 driver, which is
better structured.
TODO:
    1. Change Kconfig file - select I3000 for i82975x support
    2. Delete i82975x_edac.c file
    3. Update MAINTAINERS file
>

Arvind
