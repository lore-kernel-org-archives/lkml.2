Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0KOSd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:33:28 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:33594 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab0KOSd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:33:27 -0500
X-ASG-Debug-ID: 1289846006-08b795fe0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE17CF1.3010009@fusionio.com>
Date: Mon, 15 Nov 2010 19:33:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] fix amiga and atari floppy driver compile warning
References: <20101028184223.GG30148@redhat.com> <20101115152709.GF30792@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] fix amiga and atari floppy driver compile warning
In-Reply-To: <20101115152709.GF30792@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289846006
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46721
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-15 16:27, Vivek Goyal wrote:
> On Thu, Oct 28, 2010 at 02:42:23PM -0400, Vivek Goyal wrote:
>> Geert, my crosstool don't produce warning below. I guess this has to do
>> something with compiler version.
>>
>> - Geert noticed following warning during compilation.
>>
>>   drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized in
>>   this function
>>   drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized in
>>   this function
>>
>> - Initialize rq to NULL to fix the warning. If we can't find a suitable request
>>   to dispatch, this function should return NULL instead of a possibly garbage
>>   pointer.
>>
>> - Cross compile tested only. Don't have hardware to test it.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hi Jens,
> 
> Do you have any concerns about this patch? If not, can you please apply
> it.

No, it's straight forward just got missed in travel. Applied, thanks.

-- 
Jens Axboe

