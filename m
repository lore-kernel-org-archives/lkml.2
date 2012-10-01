Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2JAQis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:38:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65235 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2JAQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <5069C5AF.3030607@iki.fi>
References: <1349101213-21723-1-git-send-email-elezegarcia@gmail.com>
	<5069C5AF.3030607@iki.fi>
Date: Mon, 1 Oct 2012 13:38:46 -0300
Message-ID: <CALF0-+WR1cjkAEVPGU53jrdthwM1wm2EAr-OmMa0xtKiZO1TBg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add stk1160 driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 1:32 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 10/01/2012 05:20 PM, Ezequiel Garcia wrote:
>>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>>   MAINTAINERS |    7 +++++++
>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0750c24..17f6fb0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3168,6 +3168,13 @@ T:       git
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
>>   S:    Maintained
>>   F:    drivers/media/usb/gspca/
>>
>> +STK1160 USB VIDEO CAPTURE DRIVER
>> +M:     Ezequiel Garcia <elezegarcia@redhat.com>
>
>
> Copy paste mistake?
>

Indeed. Thanks for pinpointing that :-)

>
>> +L:     linux-media@vger.kernel.org
>> +T:     git
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
>> +S:     Maintained
>> +F:     drivers/media/usb/stk1160/
>> +
>>   HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
>>   M:    Frank Seidel <frank@f-seidel.de>
>>   L:    platform-driver-x86@vger.kernel.org
>>
>
> regards
> Antti
>
> --
> http://palosaari.fi/
