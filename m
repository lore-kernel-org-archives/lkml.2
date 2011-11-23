Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1KWGgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:36:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64751 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab1KWGga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111122222149.GH24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-9-git-send-email-corentincj@iksaif.net>
	<20111122222149.GH24283@suse.de>
Date: Wed, 23 Nov 2011 07:28:31 +0100
Message-ID: <CAHR064jWCgy3HwiwJkTRU3pTwz30wUasv33M0wEAwF_==T7+VA@mail.gmail.com>
Subject: Re: [PATCH 08/15] samsung-laptop: add battery life extender support
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Matthew Garrett <mjg@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:21 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:39PM +0100, Corentin Chary wrote:
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>> ---
>>  .../ABI/testing/sysfs-driver-samsung-laptop        |   10 +++
>>  drivers/platform/x86/samsung-laptop.c              |   82 ++++++++++++++++++++
>>  2 files changed, 92 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-samsung-laptop b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
>> index 0a81023..a6a56e1 100644
>> --- a/Documentation/ABI/testing/sysfs-driver-samsung-laptop
>> +++ b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
>> @@ -17,3 +17,13 @@ Description:       Some Samsung laptops have different "performance levels"
>>               Specifically, not all support the "overclock" option,
>>               and it's still unknown if this value even changes
>>               anything, other than making the user feel a bit better.
>> +
>> +What:                /sys/devices/platform/samsung/battery_life_extender
>> +Date:                December 1, 2011
>> +KernelVersion:       3.3
>> +Contact:     Corentin Chary <corentin.chary@gmail.com>
>> +Description: Max battery charge level can be modified, battery cycle
>> +             life can be extended by reducing the max battery charge
>> +             level.
>> +             0 means normal battery mode (100% charge)
>> +             1 means battery life extender mode (80% charge)
>
> Really?  Huh, learn something new every day, that's rally cool, nice
> job.

Maybe it's only marketing bullshit... but the option is present both
in the BIOS and on windows, so it looks like a real feature.


-- 
Corentin Chary
http://xf.iksaif.net
