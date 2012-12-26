Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2LZBx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:53:29 -0500
Received: from intranet.asianux.com ([58.214.24.6]:8951 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2LZBxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:53:25 -0500
X-Spam-Score: -100.8
Message-ID: <50DA58CA.2060700@asianux.com>
Date: Wed, 26 Dec 2012 09:54:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: strcpy and strncpy,
 src length checking issue.
References: <50CAA1F2.9000003@asianux.com> <50CFD786.5010101@asianux.com> <CAJ6Av5NtM06aTsGzE+4cYH-TM2fkN3Ek0f=OuR=_abDtta1FDA@mail.gmail.com>
In-Reply-To: <CAJ6Av5NtM06aTsGzE+4cYH-TM2fkN3Ek0f=OuR=_abDtta1FDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月24日 22:27, Omar Ramirez Luna 写道:
> Hi Gchen,
> 
> On Mon, Dec 17, 2012 at 8:40 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> Hello Omar Ramirez Luna:
>>
>>   excuse me to bother you (maybe you are busy in these days).
>>   please help checking this suggestion when you have free time.
> 
> Yes, I'm checking your suggestions, I was a little busy last week, for
> the compile breaks I had a patch but I was waiting for them to show on
> staging 3.8-rc1.
> 

  ok, I should wait for some days, at least.

  :-)

>> By the way:
>>   this week, I need work for 2 patches which relative with usb sub-system.
>>   if still get no reply for tidspbridge until next week.
>>     I should work for it, it is my duty (since I have provided 'suggestion' to it).
>>     "work for it" means:
>>        if tidspbridge is still useful
>>          I need construct relative environments for unit test.
>>          then provide relative patches.
>>        else (useless)
>>          I need delete it from Open Source.
>>          (since it can not pass compiling, and no response from *@ti.com, it almost means useless)
> 
> Please DON'T assume it's useless if you don't get replies from @ti.com .

  ok.

-- 
Chen Gang

Asianux Corporation
