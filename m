Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1HKIgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:36:51 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:60542 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1HKIgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:36:50 -0400
X-ASG-Debug-ID: 1313051806-01de280c1e13c2c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E43949A.7000306@fusionio.com>
Date: Thu, 11 Aug 2011 10:36:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Namhyung Kim <namhyung@gmail.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 2/2] blktrace: add FLUSH/FUA support
References: <1312957924-2316-1-git-send-email-namhyung@gmail.com> <1312957924-2316-2-git-send-email-namhyung@gmail.com> <x497h6ls781.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v2 2/2] blktrace: add FLUSH/FUA support
In-Reply-To: <x497h6ls781.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313051806
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71439
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-10 15:53, Jeff Moyer wrote:
> Namhyung Kim <namhyung@gmail.com> writes:
> 
>> Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
>> FUA follows WRITE, use the same 'F' flag for both cases and
>> distinguish them by their (relative) position. The end results
>> look like (other flags might be shown also):
>>
>>  - WRITE:            W
>>  - WRITE_FLUSH:      FW
>>  - WRITE_FUA:        WF
>>  - WRITE_FLUSH_FUA:  FWF
> 
> I was hoping we'd go with Jens' suggestion of relacing W with F for flush,
> and have FUA appear after that.  However, I can live with this, so if
> others like it, it's fine by me.

The single 'F' would have been cleaner, but at least this is consistent.
Applied, thanks.

-- 
Jens Axboe

