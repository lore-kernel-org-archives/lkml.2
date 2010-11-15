Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab0KOSdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:33:45 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:33601 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab0KOSdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:33:44 -0500
X-ASG-Debug-ID: 1289846023-08b796000001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE17D03.7030909@fusionio.com>
Date: Mon, 15 Nov 2010 19:33:39 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "yummylln@yahoo.com.cn" <yummylln@yahoo.com.cn>
Subject: Re: [PATCH] blk-throttle: Fix calculation of max number of WRITES
  to be dispatched
References: <20101027172941.GD12981@redhat.com> <20101115152802.GG30792@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-throttle: Fix calculation of max number of WRITES
  to be dispatched
In-Reply-To: <20101115152802.GG30792@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289846023
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

On 2010-11-15 16:28, Vivek Goyal wrote:
> On Wed, Oct 27, 2010 at 01:29:41PM -0400, Vivek Goyal wrote:
>> o Currently we try to dispatch more READS and less WRITES (75%, 25%) in one
>>   dispatch round. ummy pointed out that there is a bug in max_nr_writes
>>   calculation. This patch fixes it.
>>
>> Reported-by: ummy y <yummylln@yahoo.com.cn>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
> 
> Hi Jens,
> 
> Do you have any concerns about this patch? If not, can you please apply
> it.

Applied, thanks.

-- 
Jens Axboe

