Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1AJSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:50:00 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:47423 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab1AJSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:49:57 -0500
X-ASG-Debug-ID: 1294685396-71f78bb10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D2B54CE.3080301@fusionio.com>
Date: Mon, 10 Jan 2011 19:49:50 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "ltuikov@yahoo.com" <ltuikov@yahoo.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
References: <1266.36669.qm@web31807.mail.mud.yahoo.com>
X-ASG-Orig-Subj: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
In-Reply-To: <1266.36669.qm@web31807.mail.mud.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294685396
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.51996
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-10 18:26, Luben Tuikov wrote:
> Commit 67869fb9fdfa04503b250d59e086c15f1698aea0

That commit isn't a valid sha in my tree. What commit do you mean?

> skipped tag 0 by virtue of setting last_tag to
> 0. This commit sets it to -1, in order to start
> and loop over from 0, thus generating tags
> [0,max_tag-1], instead of [1,max_tag-1].

Irregardless, patch looks good. That's definitely a bug. Thanks!


-- 
Jens Axboe

