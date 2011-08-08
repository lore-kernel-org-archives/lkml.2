Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1HHPDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:03:17 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:44526 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab1HHPDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:03:16 -0400
X-ASG-Debug-ID: 1312815795-03d6a510a626df80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3FFAB0.40205@fusionio.com>
Date: Mon, 8 Aug 2011 17:03:12 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
References: <20110808145826.GA22457@redhat.com>
X-ASG-Orig-Subj: Re: exception in interrupt during elv_completed_request. (3.0)
In-Reply-To: <20110808145826.GA22457@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312815795
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71209
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-08 16:58, Dave Jones wrote:
> Jens,
> 
> We got a report of a panic from a user when he plugged in his usb drive,
> https://bugzilla.redhat.com/attachment.cgi?id=517141
> 
> any ideas what happened here ?

2.6.40?

Looks like the recent SCSI removal oopses, perhaps it happened when he
yanked it instead of directly on insertion?

-- 
Jens Axboe

