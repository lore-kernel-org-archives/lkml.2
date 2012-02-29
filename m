Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2B2B5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:57:51 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60876 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692Ab2B2B5t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:57:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.112.103.8 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120228164413.GA11021@kroah.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
	<20120228164413.GA11021@kroah.com>
Date: Wed, 29 Feb 2012 10:57:48 +0900
Message-ID: <CAJ0PZbQ9iTO+CqNLyAYiRFq8BqZXoyLfBFGvw78k53C+4yLY=w@mail.gmail.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 1:44 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Feb 28, 2012 at 05:58:02PM +0900, MyungJoo Ham wrote:
>> Hello Arnd,
>>
>>
>> Presuming that the requests and comments upto v5 patchsets were
>> addressed in the last patchset (v6), here goes a pull request of
>> Extcon.
>
> Wait, please, before this code can be accepted, I would like to get
> verification that you have also made the needed changes to the Android
> userspace side of this interface, and that the code works there, and it
> is on its way to be included in the main Android repo.
>
> Is this true?  If not, what is the plans for this to happen?  Without
> that happening, I don't think this code can be accepted, do you?
>
> thanks,
>
> greg k-h

When an extcon device driver is not using the extended features
(multistate & mutually-exclusiveness) and CONFIG_ANDROID is on, the
userspace interface is same as the Android kernel's switch class (name
and state ABI, which were read-only in Android kernel).

If an extcon device drivers uses the extended features (multistate &
mutually-exclusiveness) by adding "cable names", the state ABI will
provided information in different format. Besides, Android kernel's
switch device driver cannot provide the extended feature anyway.


Thanks.


Cheers!
MyungJoo.
-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
