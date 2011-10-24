Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1JXOMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:12:17 -0400
Received: from brick.kernel.dk ([87.104.106.3]:55789 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab1JXOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:12:16 -0400
Message-ID: <4EA57236.6060107@kernel.dk>
Date: Mon, 24 Oct 2011 16:12:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Remove the control of complete cpu from bio.
References: <1316166108-6465-1-git-send-email-tm@tao.ma> <4EA4DFAE.4030407@tao.ma>
In-Reply-To: <4EA4DFAE.4030407@tao.ma>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-24 05:46, Tao Ma wrote:
> On 09/16/2011 05:41 PM, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> bio originally has the functionality to set the complete cpu, but
>> it is broken.
>>
>> Chirstoph said that "This code is unused, and from the all the
>> discussions lately pretty obviously broken.  The only thing keeping
>> it serves is creating more confusion and possibly more bugs."
>>
>> And Jens replied with "We can kill bio_set_completion_cpu(). I'm fine
>> with leaving cpu control to the request based drivers, they are the
>> only ones that can toggle the setting anyway".
>>
>> So this patch tries to remove all the work of controling complete cpu
>> from a bio.

Applied, thanks!

-- 
Jens Axboe

