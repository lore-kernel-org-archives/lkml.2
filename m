Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0LIAf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:35:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53109 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab0LIAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:35:26 -0500
Message-ID: <4D001BB4.4040906@oracle.com>
Date: Wed, 08 Dec 2010 15:58:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com> <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com> <1291801990.5992.105.camel@i7.infradead.org> <20101208174603.GA7107@core.coreip.homeip.net> <20101208135105.a8482d46.randy.dunlap@oracle.com> <1291849721.5992.145.camel@i7.infradead.org> <20101208233101.GA15294@core.coreip.homeip.net> <1291851309.5992.150.camel@i7.infradead.org> <20101208234950.GB15294@core.coreip.homeip.net>
In-Reply-To: <20101208234950.GB15294@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/10 15:49, Dmitry Torokhov wrote:
> On Wed, Dec 08, 2010 at 11:35:08PM +0000, David Woodhouse wrote:
>> On Wed, 2010-12-08 at 15:31 -0800, Dmitry Torokhov wrote:
>>> Even better tool would allow selecting the needed optios right there,
>>> without the need of moving away from teh current option.
>>
>> That's exactly what the Nemesis version of xconfig did, almost 15 years
>> ago.
>>
>>>  And yet better tool would not even ask user and enable them on its
>>> own. Hey, but we have it! It's called "select".
>>
>> The tools could do that with 'depends on' too. Why make a distinction?
> 
> To allow automatic/manual selection. Sometimes the only answer to
> "shoudl it be enabled" is "Yes". I.e. drivers that need polling need
> input-polldev support. There is no reason whatsoever to even ask user.
> 
> Same thing for platform drivers. "Don't you also want to enable option for
> your keyboard and mouse to work? Go do that, you won't regret." "Well,
> duh!"
> 
>>
>>> Seriously, select is dangerous. I wonder if a rule like "One can only
>>> select a symbol whose dependencies are all satisfied by the current
>>> symbol and/or its parents and the symbols they select or depend on"
>>> would not make select safe enough. 
>>
>> "One can only select a symbol which isn't otherwise presented to the
>> user as a choice".
> 
> Input-polldev _is_ presented as a choice in case user or distro want to
> use out of tree driver that depends on it. Does this mean we shoudl
> disallow selects on it? I don't think so.

To me it means that we have too many config options, but I'm sure that some
embedded people would disagree with that.

| GUI tools have means of presenting this, menuconfig and oldconfig have
| harder time...

Sure, I know that.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
