Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1L2S0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 13:26:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1L2S0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 13:26:50 -0500
MIME-Version: 1.0
In-Reply-To: <4EF4CE4A.1020907@gmail.com>
References: <1324651260-4067-1-git-send-email-benjamin.tissoires@gmail.com>
	<1324651260-4067-2-git-send-email-benjamin.tissoires@gmail.com>
	<4EF4CE4A.1020907@gmail.com>
Date: Thu, 29 Dec 2011 19:26:47 +0100
Message-ID: <CAN+gG=HgdgNt4x8V7XgN5J-enQDWfDP3urEn8e7QTipWpFNL9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: multitouch: add support of Atmel multitouch panels
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chase,

Well, this is the "Atmel maXTouch Digitizer" found on Samsung "Series
7 Slate" XE700T1A.

Same device here:
http://www.spinics.net/lists/xorg/msg53376.html

Cheers,
 and happy new year,
Benjamin

On Fri, Dec 23, 2011 at 19:54, Chase Douglas <chasedouglas@gmail.com> wrote:
> On 12/23/2011 06:40 AM, Benjamin Tissoires wrote:
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/Kconfig          |    1 +
>>  drivers/hid/hid-ids.h        |    3 +++
>>  drivers/hid/hid-multitouch.c |    5 +++++
>>  3 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 5d6eb4e..e95b07c 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -335,6 +335,7 @@ config HID_MULTITOUCH
>>         Say Y here if you have one of the following devices:
>>         - 3M PCT touch screens
>>         - ActionStar dual touch panels
>> +       - Atmel panels
>>         - Cando dual touch panels
>>         - Chunghwa panels
>>         - CVTouch panels
>
> I'm guessing this is different than the Atmel maXTouch chips. If so, can
> you figure out a model name so people aren't confused on which driver to
> use?
>
> -- Chase
