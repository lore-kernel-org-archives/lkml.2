Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0C0Lw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 07:52:26 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:44302 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0C0LwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 07:52:25 -0400
Message-ID: <4BADF177.1070201@shikadi.net>
Date: Sat, 27 Mar 2010 21:52:23 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: usbhid: How to wait for response after submitting report
References: <4B9B022F.6060402@shikadi.net> <alpine.LNX.2.00.1003151706330.18642@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003151706330.18642@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm working on a USB HID driver, but my driver seems to be receiving bad data.
>>  I think it's because usbhid_submit_report is non-blocking and I'm not
>> correctly waiting for a response.  I'm not sure though, because none of the
>> existing usbhid drivers seem to work in this way.
>>
>> Could someone please let me know if I'm going about this the right way?
> 
> I am afraid you'll have to explain in more detail what exactly you are 
> tying to achieve, and why the way the current HID code does it (i.e. URB 
> gets submitted, completion handler is called when completed) doesn't work 
> for you.

Thanks Jiri, it's probably because I still don't know what I'm doing :-)  Can
you point me at any HID examples that show how to use a completion handler?
I'm afraid after hours of staring at HID code I'm still none the wiser as to
how this part of the system works.

Basically I have a USB HID device, and it works by submitting a HID report,
then waiting until it replies with (I assume) another HID report.  The
messages are all proprietary.  I can send the reports fine, but half the time
I get garbage coming back, which I assume is because I'm not getting the
message quickly enough and processing whatever was in the buffer instead.

If you're able to point me in the direction of an example showing how to set
up and use a completion handler, hopefully I can change my code to work like
that instead.

Many thanks,
Adam.
