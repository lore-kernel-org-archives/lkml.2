Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1EXPBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:01:01 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:56289 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1EXPA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:00:59 -0400
X-ASG-Debug-ID: 1306249258-01de28096b60d20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDBC826.2010602@fusionio.com>
Date: Tue, 24 May 2011 17:00:54 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 2/2] loop: handle on-demand devices correctly
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>	 <1306247761-2246-2-git-send-email-namhyung@gmail.com>	 <4DDBC4A7.1040104@fusionio.com> <1306249066.1751.7.camel@leonhard>
X-ASG-Orig-Subj: Re: [PATCH 2/2] loop: handle on-demand devices correctly
In-Reply-To: <1306249066.1751.7.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306249258
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 16:57, Namhyung Kim wrote:
> 2011-05-24 (화), 16:45 +0200, Jens Axboe:
>> Thanks, applied. Seems we should mark this for stable.
>>
> 
> Hi Jens,
> 
> The partition handling was introduced by commit 476a4813cfdd ("loop:
> manage partitions in disk image") so that we need these patches for all
> stable releases, AFAICS.
> 
> $ git name-rev --tags 476a4813cfdd
> 476a4813cfdd tags/v2.6.26-rc1~1115^2~9

Thanks, I have committed with a stable marker.

> Now I can see that brd (ramdisk) module seems to have same problems with
> loop. I'll work on that, too.

Good catch, btw!

-- 
Jens Axboe

