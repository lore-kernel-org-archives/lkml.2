Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0LHUha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:37:30 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:55434 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab0LHUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:37:27 -0500
Message-ID: <4CFFEC71.8060103@euromail.se>
Date: Wed, 08 Dec 2010 21:37:05 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <25336.1291839964@localhost>
In-Reply-To: <25336.1291839964@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQQlA-00032L-4n.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQQlA-00032L-4n 5019aba0ea172269222de6bdcb3fa5f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

>>  /*
>> + * Device types
>> + */
>> +
>> +#define DEVTYPE_KEYBOARD	0
>> +#define DEVTYPE_MOUSE		1
>> +#define DEVTYPE_JOYSTICK	2
>> +#define DEVTYPE_TOUCHPAD	3
>> +#define DEVTYPE_TABLET		4
>> +#define DEVTYPE_TOUCHSCREEN	5
> 
> Add a #define DEVTYPE_UNKNOWN 0 and push everybody else down one. That way,
> an uninitialized 'struct input_devinfo' won't claim to be a keyboard.


Since types is a bitmask, the initial value will actually be unclaimed already.
To be explicit, for a keyboard, types = 1 << 0 = 1.

Thanks,
Henrik
