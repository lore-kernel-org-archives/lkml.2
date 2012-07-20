Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2GTPfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:35:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35756 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2GTPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <13845450.qTFZGkrci5@linux-lqwf.site>
References: <1342789042-13433-1-git-send-email-johannes.winkelmann@sensirion.com>
	<6190165.D1PKLQQHEK@linux-lqwf.site>
	<CAEYbzYsu_xhXJgbYKPj-rz-d26wTTM98+oyEDWbXMO5VNC5sgw@mail.gmail.com>
	<13845450.qTFZGkrci5@linux-lqwf.site>
Date: Fri, 20 Jul 2012 17:35:10 +0200
Message-ID: <CAEYbzYuDJLarBULPz1ooSiLhtFsL-YZ-DAxwFW76LnmQ67n5Qw@mail.gmail.com>
Subject: Re: [RFC][PATCH] hwmon: add support for Sensirion C1 sensor
From: Johannes Winkelmann <johannes.winkelmann@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Johannes Winkelmann <johannes.winkelmann@sensirion.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 5:14 PM, Oliver Neukum <oneukum@suse.de> wrote:
> On Friday 20 July 2012 17:13:51 Johannes Winkelmann wrote:
>> On Fri, Jul 20, 2012 at 4:03 PM, Oliver Neukum <oneukum@suse.de> wrote:
>
>> > We have dedicated macros for conversion of endianness.
>>
>> Like this:
>>               val = swab16p((__le16 *)buf);
>>               data->temperature = ((21875 * val) >> 13) - 45000;
>>               val = swab16p((__le16 *)(buf+2));
>>               data->humidity = ((15000 * val) >> 13) - 10000;
>
> I was thinking of be16_to_cpu()

Ok, fixed locally; I'll collect some more feedback and will resubmit v2

Thanks,
Johannes
-- 
Johannes Winkelmann
jw@smts.ch
