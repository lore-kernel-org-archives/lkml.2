Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0JWPVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:21:19 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:20404 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757416Ab0JWPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:21:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHeawkxLd/sX/2dsb2JhbAAHgxfIYJFZgSKDMnQEj1E
X-IronPort-AV: E=Sophos;i="4.58,228,1286164800"; 
   d="scan'208";a="80487141"
Message-ID: <4CC2FD6D.3080709@teksavvy.com>
Date: Sat, 23 Oct 2010 11:21:17 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com> <4CC24186.1040001@teksavvy.com> <25B374CC0D9DFB4698BB331F82CD0CF20D5FFC@wdscexbe08.sc.wdc.com>
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D5FFC@wdscexbe08.sc.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-22 10:21 PM, Daniel Taylor wrote:
>Mark Lord wrote:
>>
>> The RocketRaid BIOS that I examined here a couple of years ago,
>> liked to write "metadata" over top of whatever was in certain sectors
>> near the end of the drive.  EVEN FOR NON-RAID DRIVES.
>>
>> I think it was the last even (power-of-two) multiple of 1GB
>> or something,
>> so if you leave the final 2GB untouched, you're guaranteed to
>> avoid it.
>>
>> Thus the recommendation.
>
> What happens to the backup GPT at the end of the disk?

Dunno.
