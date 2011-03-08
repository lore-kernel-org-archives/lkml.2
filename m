Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1CHSph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:45:37 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:32862 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1CHSph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:45:37 -0500
X-ASG-Debug-ID: 1299609936-03d6a54f62295d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D76794C.3040102@fusionio.com>
Date: Tue, 8 Mar 2011 19:45:32 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][resend] blk-cgroup: Lower minimum weight from 100 to
 10.
References: <1299600291-30388-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH][resend] blk-cgroup: Lower minimum weight from 100 to
 10.
In-Reply-To: <1299600291-30388-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.101.1.21]
X-Barracuda-Start-Time: 1299609936
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57430
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-08 17:04, Justin TerAvest wrote:
> We've found that we still get good, useful isolation at weights this
> low. I'd like to adjust the minimum so that any other changes can take
> these values into account.

Thanks, applied.

-- 
Jens Axboe

