Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2B2CFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:05:42 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56467 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2B2CFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:05:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.152.125.41 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120228174505.GP3683@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
	<20120228164413.GA11021@kroah.com>
	<20120228165727.GO3683@opensource.wolfsonmicro.com>
	<20120228170246.GA11415@kroah.com>
	<20120228174505.GP3683@opensource.wolfsonmicro.com>
Date: Wed, 29 Feb 2012 11:05:39 +0900
Message-ID: <CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 2:45 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Feb 28, 2012 at 09:02:46AM -0800, Greg KH wrote:
>> On Tue, Feb 28, 2012 at 04:57:28PM +0000, Mark Brown wrote:
>
>> > There's a few more kernel changes needed there before full acceptance
>> > would be possible - for example, should have an integration into the
>> > audio stack as one of the uses of the switch API on Android is for
>> > headset detection.
>
>> Is this integration planned?
>
> Don't know if anyone has a specific plan at the moment, though there's
> enough people care that I'd imagine it'll happen if Android decides to
> use this stuff.
>
> That said I don't see this as a blocker myself - it's more like an
> afternoon or whatever of work than a serious development effort to do
> the updates, but a similar thing applies to most of the Android
> userspace updates.

I'm not sure which Android kernel devide drivers are going to be upstreamed.

However, if the swtich device driver writers decide to keep the
functionality limited to the original Android switch class by not
providing cable names additionally, the changes will probably be
limited to ":s/switch/extcon/g" for API calls and struct name.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
