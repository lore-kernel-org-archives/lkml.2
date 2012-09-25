Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2IYO0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:26:08 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:43504 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab2IYO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:26:06 -0400
Message-ID: <5061BEDF.9010700@ti.com>
Date: Tue, 25 Sep 2012 19:55:35 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, akpm@linux-foundation.org, a.zummo@towertech.it
Subject: Re: [PATCHv3 0/7] rtc: convert to c99 format
References: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com> <20120925120918.GZ9137@arwen.pp.htv.fi>
In-Reply-To: <20120925120918.GZ9137@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012 05:39 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Sep 25, 2012 at 05:01:59PM +0530, Shubhrajyoti D wrote:
>> The series tries to convert the i2c_msg to c99 struct.
>> This may avoid issues like below if someone tries to add a
>> structure.
>> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
>>
>> Special thanks to Julia Lawall for helping it automate.
>> By the below script.
>> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
>>  
>> Resending with Andrew Morton in cc for review as it was suggested to me.
>>
>> Fix a typo in the comments that crept in.
>>
>> Shubhrajyoti D (7):
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
>>   rtc: Convert struct i2c_msg initialization to C99 format
> FWIW:
>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
>
> complete series look fine.
thanks.
>

