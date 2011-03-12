Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1CLPt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 10:49:57 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:55810 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab1CLPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 10:49:56 -0500
X-ASG-Debug-ID: 1299944994-03d6a54f625afb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7B961F.9090702@fusionio.com>
Date: Sat, 12 Mar 2011 16:49:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add unaccounted time to timeslice_used.
References: <1299877572-30353-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH] Add unaccounted time to timeslice_used.
In-Reply-To: <1299877572-30353-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299944994
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57742
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 22:06, Justin TerAvest wrote:
> There are two kind of times that tasks are not charged for: the first
> seek and the extra time slice used over the allocated timeslice. Both
> of these exported as a new unaccounted_time stat.
> 
> I think it would be good to have this reported in 'time' as well, but
> that is probably a separate discussion.

I think that is a very good idea, helps to build confidence when
testing. I'll apply this, thanks Justin.

-- 
Jens Axboe

