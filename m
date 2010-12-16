Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0LPHoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:44:10 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47014 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab0LPHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:44:08 -0500
Message-ID: <4D09C306.4050207@euromail.se>
Date: Thu, 16 Dec 2010 08:43:02 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Chase Douglas <chase.douglas@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] input: Introduce device information ioctl
References: <1292440807-18502-1-git-send-email-rydberg@euromail.se> <4D09302C.4000309@canonical.com> <201012151352.23229.dmitry.torokhov@gmail.com>
In-Reply-To: <201012151352.23229.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PT8Uh-0005lm-8D.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PT8Uh-0005lm-8D 1361fbabe0bd708ac5532f3e2920833d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> As an example of how this would work for the

>>> touchpad/tablet/touchscreen triplet, there are two properties defined,
>>> INPUT_PROP_POINTER and INPUT_PROP_DIRECT. A touchpad is an indirect
>>> pointer device, a tablet is a direct pointer device, and the
>>> touchscreen is simply a direct device.
>>>
>>> What do you think?
>>
>> I must have missed the first version of this patch, but I give two
>> thumbs way up :). The detection code for touchpad/tablet/touchscreen in
>> xf86-input-evdev is large and unwieldy, and seemingly simple changes to
>> an input driver can cause incorrect interpretation. Having this
>> available should help quite a bit!
>>
>> Acked-by: Chase Douglas <chase.douglas@canonical.com>
> 
> As long as we document that !pointer && !direct means "unknown" or
> "unspecified" so as to avoid having to update all devices at once that
> should be OK.
> 
> We also need to wire up uinput.


Great, will cook a proper patch.

Thanks,
Henrik
