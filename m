Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1FBLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:16:58 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:41697 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab1FBLQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:16:57 -0400
X-ASG-Debug-ID: 1307013416-01de280c1e186e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE77125.6000800@fusionio.com>
Date: Thu, 2 Jun 2011 13:16:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [git pull v3.0-rc1] What branch to base fixes for v3.0-rc1 for
  block system?
References: <20110531191039.GA5269@dumpdata.com> <4DE54097.7060000@fusionio.com> <20110601151513.GB32270@dumpdata.com>
X-ASG-Orig-Subj: Re: [git pull v3.0-rc1] What branch to base fixes for v3.0-rc1 for
  block system?
In-Reply-To: <20110601151513.GB32270@dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307013416
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65383
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 17:15, Konrad Rzeszutek Wilk wrote:
> On Tue, May 31, 2011 at 09:25:11PM +0200, Jens Axboe wrote:
>> On 2011-05-31 21:10, Konrad Rzeszutek Wilk wrote:
>>> Hey Jens,
>>>
>>> I've got two tiny fixes for the xen-blkback (see below):
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens/xen-blkback.fixes
>>>
>>> and they are based on for-2.6.40/drivers branch. Is that the way you
>>> prefer to pull patches from sub-trees? Or should I rebase it on 3.0-rc1?
>>> Or should send bug-fixes just directly to Linus?
>>
>> Once I send off the big initial merges which are in the version named
>> for-2.6.40/xx branches, anything after that should just be based on my
>> for-linus branch. That's what I use for post-rc1 merges with Linus.
>>
>> But the only real sticking point is that your branch should not contain
>> something that I don't have in my for-linus. And you don't right now, so
>> I just pulled it :-)
> 
> Can you repull that branch please? I've rebased it on for-linus branch
> and fixed the embarrassing compilation issue it had..

Repulled, and it seems to compile as well this time :-)

-- 
Jens Axboe

