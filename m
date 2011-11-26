Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1KZFql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 00:46:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44331 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1KZFqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 00:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <201111251402.28016.arnd@arndb.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
Date: Sat, 26 Nov 2011 14:46:38 +0900
Message-ID: <CAJ0PZbQEpnJoKaX-BOMPN-=xQAKLegkqBf52azAF_Xosxi8ukQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 11:02 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 24 November 2011, MyungJoo Ham wrote:
>> For switch ports, which may have different types of cables
>> (USB, TA, HDMI, Analog A/V, and others), we often have seperated device
>> drivers that detect the state changes at the port and device drivers that
>> do something according to the state changes.
>>
>> For example, when MAX8997-MUIC detects a Charger cable insertion, another
>> device driver (such as MAX8903 charger, MAX8997 charger, Charger Manager,
>> or board file) needs to set charger current limit accordingly and when
>> MAX8997-MUIC detects a HDMI cable insertion, multimedia device drivers
>> need to do some operations accordingly.
>>
>> This patchset supports the usage of notifier for passing such information
>> between device drivers.
>>
>> Another issue is that at a single switch port, there might be multiple
>> and heterogeneous cables attached at the same time. Besides, the state
>> (Attached or Detached) of each cable may alter independently.
>>
>> In order to address such issues, Android kernel's "Switch" class seems to
>> be a good basis and we have implemented "Multistate Switch Class" based on
>> it. The "Switch" class code of Android kernel is GPL as well.
>
> How does this relate to the new "pinmux" subsystem that Linus Walleij
> maintains? Would it be useful to integrate your driver into pinmux
> instead of starting a new subsystem?
>
>        Arnd
>

I haven't thought about pinmux subsystem and wasn't aware of it.
However the name, pinmux, suggests that it supports similar devices if
not same. I'll read pinmux subsystem first. Thamks a lot.

Cheers!
MyungJoo



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
