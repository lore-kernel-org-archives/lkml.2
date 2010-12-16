Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0LPOSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:18:35 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:43618 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756090Ab0LPOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:18:33 -0500
Message-ID: <4D0A1FA9.5030005@euromail.se>
Date: Thu, 16 Dec 2010 15:18:17 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] input: Introduce device information ioctl
References: <1292440807-18502-1-git-send-email-rydberg@euromail.se> <20101216002941.GC4952@salty.local>
In-Reply-To: <20101216002941.GC4952@salty.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTEew-0008Dm-52.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTEew-0008Dm-52 ab62c8661d32007d0a32fe409269cfd1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>  /*
>> + * Device properties and quirks
>> + */
>> +
>> +#define INPUT_PROP_POINTER		0x00	/* needs a pointer */
>> +#define INPUT_PROP_DIRECT		0x01	/* direct object manipulation */
> 
> fwiw, I think the common term for these is "direct input devices", at least
> that's how a lot of the research literature refers to them. Might be good to
> use the same term.


Changed, thanks.


> either way, not sure about this one.  I've worked with devices that were
> indirect by nature but used directly. e.g. the magic touchpad could quite
> easily be used as direct input device with an top-down projector. the
> decision to use it as an indirect device is a UI decision.
> Likewise, some mountable direct-touch touchscreens can be used indirectly if
> the touchscreen isn't mounted straight on the display. This is very much a
> setup-specific property and I'm not sure about the value of this
> information.


As Dmitry stated already, this is foremost for automatic setup. The idea to
elevate these properties to the main configuration source is also interesting.

Thanks,
Henrik
