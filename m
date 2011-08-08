Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1HHIQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:16:52 -0400
Received: from mout1.freenet.de ([195.4.92.91]:48947 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1HHIQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:16:51 -0400
Message-ID: <4E3F9B71.7040206@01019freenet.de>
Date: Mon, 08 Aug 2011 10:16:49 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Firefox/5.0 SeaMonkey/2.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0: broken ums_eneub6250
References: <hjXX6-Ee-55@gated-at.bofh.it> <hk6nE-6kT-5@gated-at.bofh.it> <hk7Wq-mZ-1@gated-at.bofh.it> <j1mm4l$55a$1@ID-44327.news.uni-berlin.de> <20110808042231.GA6248@kroah.com>
In-Reply-To: <20110808042231.GA6248@kroah.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH schrieb:
> On Sun, Aug 07, 2011 at 08:39:20PM +0200, Andreas Hartmann wrote:
>> Hi,
>>
>> obviously, nobody seems to be interested to work on this bug. Until it's
>> fixed: There is a workaround to get the device working again with 2.6.39
>> and 3.0 - just remove the unusable ums-eneub6250.ko and replace it with
>> the complete old and fine keucr-module - staging but working :-)
>>
>> https://bugzilla.novell.com/show_bug.cgi?id=709243#c1
> 
> How about working on a patch for the in-kernel version of the code to
> get it to work properly so we can resolve this?

If I would be able do this, I would have done it! On the other side: Why
should I do it, if there is a module, which works just fine?

But you could send me patches which I could test.

>  Given that very few
> people actually have this hardware,

It's a MSI CR620 notebook. I don't think, that there are just very few
out there :-).

> it's hard for us to work on the
> driver.

Why did you remove a working module if you can't ensure, that the
replacement will cover the old module 100%?

> If you could run 'git bisect' to try to find the problem, that would be
> appreciated.

I never saw it working with the ums_eneub6250 module. 2.6.38 used the
keucr module, 2.6.39 and upper the broken ums_eneub6250.

You could send me an URL which git repository to use in order to looking
for the changes, which have been done. It would be nice, if you could
tell me a starting point!


Kind regards,
Andreas
