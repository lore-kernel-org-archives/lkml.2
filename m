Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0L1PUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:20:32 -0500
Received: from blade3.isti.cnr.it ([194.119.192.19]:54294 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0L1PU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:20:28 -0500
Date: Tue, 28 Dec 2010 16:20:01 +0100
From: torn5 <torn5@shiftmail.org>
Subject: Re: Regular ext4 error warning with HD in USB dock
In-reply-to: <20101228143255.GI10149@thunk.org>
To: "Ted Ts'o" <tytso@mit.edu>, Con Kolivas <kernel@kolivas.org>,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-usb@vger.kernel.org
Message-id: <4D1A0021.70400@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
X-INSM-ip-source: 155.253.6.254 Auth Done
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org> <4D19BEF1.9010708@shiftmail.org>
 <20101228143255.GI10149@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2010 03:32 PM, Ted Ts'o wrote:
> On Tue, Dec 28, 2010 at 11:41:53AM +0100, torn5 wrote:
>    
>> This is going to be a faq...
>> I suppose the datetime is encoded (what format is that?) in that
>> long number after "at".
>>      
> Number of seconds since January 1st, 1970 midnight GMT.  (Standard
> Unix-time format).  It's hard for the kernel to decode it since it
> doesn't know what time-zone you are in, or what your local legislature
> has done vis-a-vis arbitrary and cabritious adjustments to the
> start/stop date of daylight savings time, etc.
>    

I suggest to decode it in GMT then.
Like this it's not possible to guess it's a "time" value, and hence that 
it's an *old* error. I thought it was a pointer to something, and so I 
thought the error was happening now, or more likely (since it was 
triggered after 300 seconds) that it was some inconsistency in the 
filesystem being detected now, in some kind of lazy check.
