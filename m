Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab0LMNcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:32:48 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:46633 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab0LMNcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:32:46 -0500
X-ASG-Debug-ID: 1292247164-0853c63a0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D06207B.9090702@fusionio.com>
Date: Mon, 13 Dec 2010 14:32:43 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Jeff Moyer <jmoyer@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch]block cfq: select new workload if priority changed
References: <1291871853.2323.8.camel@sli10-conroe>	 <x49sjy5ad81.fsf@segfault.boston.devel.redhat.com> <1292200792.2323.13.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch]block cfq: select new workload if priority changed
In-Reply-To: <1292200792.2323.13.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292247164
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49310
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-13 01:39, Shaohua Li wrote:
> On Fri, 2010-12-10 at 22:56 +0800, Jeff Moyer wrote:
>> Shaohua Li <shaohua.li@intel.com> writes:
>>
>>> If priority is changed, continue checking workload_expires and service tree
>>> count of previous workload is meaningless. We should always choose the workload
>>
>> I'd change that first sentence to:
>>
>>   If priority is changed, continuing to check workload_expires and
>>   service tree count of the previous workload does not make sense.
>>
>>> with lowest key of new priority in such case.
>>>
>>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>
>> This makes sense to me.
>>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Thanks, modified the the changelog.

Thanks, applied to for-2.6.38/core

-- 
Jens Axboe

