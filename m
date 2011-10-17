Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1JQHzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1JQHzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:55:05 -0400
Message-ID: <4E9BDF3B.6080602@redhat.com>
Date: Mon, 17 Oct 2011 13:24:35 +0530
From: Gopal <gtiwari@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Glenn Sommer <gsommer@datanordisk.dk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: patch for Dell ST220T Touch Screen Monitor
References: <4E9BB353.70606@redhat.com> <CAN+gG=FsAwnQH-KjmLCvYpB_MVoe0zyBOLNu1zn3YwduC37p2A@mail.gmail.com>
In-Reply-To: <CAN+gG=FsAwnQH-KjmLCvYpB_MVoe0zyBOLNu1zn3YwduC37p2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

Thanks for Informing...I think i have missed by some day may be. But i 
have fwded my patch some where around 9th Aug. 2011 also but didn't got 
any feedback on that so tried again.

thanks for informing.

gopal.








On 10/17/2011 12:38 PM, Benjamin Tissoires wrote:
> Hi Gopal,
>
> well, the device 0x1fd2:0x0064 is already supported by hid-multitouch
> since mid-August. It has been included in the for-next branch of
> Jiri's tree (see
> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commit;h=c50bb1a4005630f47b5da26336f74a485033a515
> ).
>
> As the device is a standard (Win7 compatible) hid multitouch device,
> it's better to handle it that way: you'll get multitouch support and
> there will be no cost to maintain it ;-)
>
> Cheers,
> Benjamin
>
> On Mon, Oct 17, 2011 at 06:47, Gopal<gtiwari@redhat.com>  wrote:
>> Hello Everybody,
>>
>> We have recently created Support for Dell ST2220T Touch screen monitor with
>> in the kernel hierarchy driver/input/touchscreen patch for this attach with
>> this mail.
>> Please find the attachment. I have previously also send the patch didn't got
>> any feedback so sending it again.
>>
>> thanks
>> Gopal
>>

