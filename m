Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1CWHbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:31:35 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:42164 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab1CWHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:31:30 -0400
X-ASG-Debug-ID: 1300865489-03d6a54f60c1370001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D89A1CF.1050405@fusionio.com>
Date: Wed, 23 Mar 2011 08:31:27 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cfq-iosched: Don't clear queue stats when preempt.
References: <1300833318-1072-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH v2] cfq-iosched: Don't clear queue stats when preempt.
In-Reply-To: <1300833318-1072-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300865489
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58713
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 23:35, Justin TerAvest wrote:
> For v2, I added back lines to cfq_preempt_queue() that were removed
> during updates for accounting unaccounted_time. Thanks for pointing out
> that I'd missed these, Vivek.
> 
> Previous commit "cfq-iosched: Don't set active queue in preempt" wrongly
> cleared stats for preempting queues when it shouldn't have, because when
> we choose a queue to preempt, it still isn't necessarily scheduled next.
> 
> Thanks to Vivek Goyal for figuring this out and understanding how the
> preemption code works.

Thanks to both of you, applied.

-- 
Jens Axboe

