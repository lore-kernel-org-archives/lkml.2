Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1CIH0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:26:22 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:51394 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1CIH0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:26:21 -0500
X-ASG-Debug-ID: 1299655580-03d6a54f60312e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D772B99.1050608@fusionio.com>
Date: Wed, 9 Mar 2011 08:26:17 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>
Subject: Re: blk-throttle: Use blk_plug in throttle code (Was: Re: [PATCH
 05/10]  block: remove per-queue plugging)
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com> <20110304040048.GA32404@redhat.com> <4D761FE1.20503@fusionio.com> <20110308221002.GJ27455@redhat.com>
X-ASG-Orig-Subj: Re: blk-throttle: Use blk_plug in throttle code (Was: Re: [PATCH
 05/10]  block: remove per-queue plugging)
In-Reply-To: <20110308221002.GJ27455@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299655580
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57482
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-08 23:10, Vivek Goyal wrote:
> On Tue, Mar 08, 2011 at 01:24:01PM +0100, Jens Axboe wrote:
>> On 2011-03-04 05:00, Vivek Goyal wrote:
>>> On Sat, Jan 22, 2011 at 01:17:24AM +0000, Jens Axboe wrote:
>>>
>>> [..]
>>>>  mm/page-writeback.c                |    2 +-
>>>>  mm/readahead.c                     |   12 ---
>>>>  mm/shmem.c                         |    1 -
>>>>  mm/swap_state.c                    |    5 +-
>>>>  mm/swapfile.c                      |   37 --------
>>>>  mm/vmscan.c                        |    2 +-
>>>>  118 files changed, 153 insertions(+), 1248 deletions(-)
>>>
>>> block/blk-throttle.c also uses blk_unplug(). We need to get rid of that
>>> also.
>>
>> Done.
> 
> Thanks Jens. Looking at the usage of blk_plug, i think it makes sense to
> make use of it in throttle dispatch also. Here is the patch.

Yep, it definitely does. Thanks, I'll apply this.

-- 
Jens Axboe

