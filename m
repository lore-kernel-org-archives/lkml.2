Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289Ab0KPLv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:51:56 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:38134 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981Ab0KPLvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:51:54 -0500
X-ASG-Debug-ID: 1289908312-08b79f830001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE27054.3000309@fusionio.com>
Date: Tue, 16 Nov 2010 12:51:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] block: rename trace_block_remap to  trace_block_bio_remap
References: <4AB3A393.5000709@ce.jp.nec.com> <4AB4F908.60307@ce.jp.nec.com> <20101103215047.GC26473@redhat.com> <20101115205815.GA25567@redhat.com> <20101115213444.GA25705@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v2] block: rename trace_block_remap to  trace_block_bio_remap
In-Reply-To: <20101115213444.GA25705@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289908312
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46789
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-15 22:34, Mike Snitzer wrote:
> On Mon, Nov 15 2010 at  3:58pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> Hi Jens,
>>
>> This may have slipped through while you were traveling?
>>
>> Patch is also available here:
>> https://patchwork.kernel.org/patch/300552/
>>
>> Not sure if this change is concerning on a kABI level?
> 
> To be clear: that concern/question was prompted from having taken a
> quick glance at lwn's kernel summit "KS2010: ABI status for tracepoints"
> coverage: http://lwn.net/Articles/412685/
> 
> But in that article it clearly states:
> "there are to be no stable tracepoints in drivers or filesystems".
> 
> Not sure where that leaves tracepoints for the block layer.  Anyway,
> seems tracepoint kABI is likely a concern for the future (not the
> immediate future).
> 
> So this change would be nice to get in before there is a new tracepoint
> kABI-aware sheriff in town.

As far as I'm concerned, trace point changes in the block area cannot
break existing blktrace (as in cause malfunction). So this patch is
fine, I'll pick it up for .38.

-- 
Jens Axboe

