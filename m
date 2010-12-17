Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0LQHfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 02:35:10 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:41082 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0LQHfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 02:35:08 -0500
X-ASG-Debug-ID: 1292571306-2c9d71cc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D0B129B.3070500@fusionio.com>
Date: Fri, 17 Dec 2010 08:34:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Mike Snitzer <snitzer@redhat.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH for-2.6.37] block: max hardware sectors limit wrapper
References: <20101206184346.GA13582@redhat.com> <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
X-ASG-Orig-Subj: Re: [PATCH for-2.6.37] block: max hardware sectors limit wrapper
In-Reply-To: <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292571306
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.2487 1.0000 -0.5815
X-Barracuda-Spam-Score: -0.58
X-Barracuda-Spam-Status: No, SCORE=-0.58 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49670
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-17 00:49, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Implement blk_limits_max_hw_sectors() and make
> Mike> blk_queue_max_hw_sectors() a wrapper around it.
> 
> Mike> DM needs this to avoid setting queue_limits' max_hw_sectors and
> Mike> max_sectors directly.  dm_set_device_limits() now leverages
> Mike> blk_limits_max_hw_sectors() logic to establish the appropriate
> Mike> max_hw_sectors minimum (PAGE_SIZE).  Fixes issue where DM was
> Mike> incorrectly setting max_sectors rather than max_hw_sectors (which
> Mike> caused dm_merge_bvec()'s max_hw_sectors check to be ineffective).
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Jens, please apply.

Thanks, it's in.

-- 
Jens Axboe

