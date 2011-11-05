Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1KENAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 09:00:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34874 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1KENAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 09:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <1320478202.932.YahooMailNeo@web121019.mail.ne1.yahoo.com>
References: <1320269478.98312.YahooMailNeo@web27408.mail.ukl.yahoo.com>
	<1320271853.29441.8.camel@localhost.localdomain>
	<1320273520.29441.12.camel@localhost.localdomain>
	<1320478202.932.YahooMailNeo@web121019.mail.ne1.yahoo.com>
Date: Sat, 5 Nov 2011 15:00:11 +0200
X-Google-Sender-Auth: 6uVRvDj7jVpa7Wp1YHAXYKZx8co
Message-ID: <CAM5dq2C8z27jKuhbLuW_P=f1p-NX4YNNt7oh+-ozZaksU4bWww@mail.gmail.com>
Subject: Re: Bug: [Toshiba Satellite A200] SD card recognised but not automounted
From: Avdelas Lamprakis <lamprakisa@yahoo.gr>
To: Alex Dubov <oakad@yahoo.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for you for your answers.
I am not comfortable with the tweaks that you are proposing but i will
start googling how to do them.
I will come back and inform you on my progress.

Best
Lamprakis


On 5 November 2011 09:30, Alex Dubov <oakad@yahoo.com> wrote:
>>
>
>> Am Mittwoch, den 02.11.2011, 23:10 +0100 schrieb Thomas Meyer:
>>>  Am Mittwoch, den 02.11.2011, 21:31 +0000 schrieb Lampra:
>>>  >
>>>  > Hi,
>>>
>>>  Hi Lampra.
>>
>> Added maintainer.
>>
>>>
>>>  >  this is my first bug report upstream.
>>>  >
>>>  > I use Ubuntu 11.10, when i insert an SD card in my laptop Toshiba
>>>  > Satellite A200, the card is recognised but not auto mounted.
>>>
>>>  the correct link seems to be: https://bugs.launchpad.net/bugs/878594
>>>  >
>>>  > Lamprakis
>>
>
>
> This may be some sort of conflict between sdhci (which I had not much to
> do with) and tifm, which never supported xx12 chipset properly (I only
> had xx21 to work with back then, which is somewhat different).
>
> I would start from blacklisting the tifm and trying to get sdhci working
> properly, and if it's not working that well, then blacklisting the sdhci
> and playing with tifm.
>
> Either approach may require tweaking the pci config registers, which was
> a usual game with these chipsets some years ago (done with some sysfs
> scripting).
>
> Hope this helps.
>
>
