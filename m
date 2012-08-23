Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab2HWKEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:04:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab2HWKEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:04:06 -0400
Message-ID: <50360051.9050908@redhat.com>
Date: Thu, 23 Aug 2012 12:05:05 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/radio/shark2: Fix build error caused by missing
 dependencies
References: <1345648585-5176-1-git-send-email-linux@roeck-us.net> <5034F932.4000405@redhat.com> <20120822152922.GA6177@roeck-us.net> <201208221857.01527.arnd@arndb.de>
In-Reply-To: <201208221857.01527.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/22/2012 08:57 PM, Arnd Bergmann wrote:
> On Wednesday 22 August 2012, Guenter Roeck wrote:
>> On Wed, Aug 22, 2012 at 05:22:26PM +0200, Hans de Goede wrote:
>>> Hi,
>>>
>>> I've a better fix for this here:
>>> http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6
>>>
>>> I already send a pull-req for this to Mauro a while ago, Mauro?
>>>
>> Looks like it found its way into mainline in the last couple of days.
>> Should have updated my tree first. Sorry for the noise.
>>
>
> I found another issue with the shark driver while doing randconfig tests.
> Here is my semi-automated log file for the problem. Has this also made
> it in already?

No,

Mauro, can you please add Arnd's fix for this to 3.6 ?

Thanks,

Hans
