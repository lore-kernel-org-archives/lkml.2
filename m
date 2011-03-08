Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1CHOhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:37:03 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:57360 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1CHOhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:37:00 -0500
X-ASG-Debug-ID: 1299595018-01de284cf825490001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D763F07.1070103@fusionio.com>
Date: Tue, 8 Mar 2011 15:36:55 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-cgroup: Lower minimum weight from 100 to 10.
References: <1299538394-9669-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-cgroup: Lower minimum weight from 100 to 10.
In-Reply-To: <1299538394-9669-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299595018
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57415
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 23:53, Justin TerAvest wrote:
> We've found that we still get good, useful isolation at weights this
> low. I'd like to adjust the minimum so that any other changes can take
> these values into account.

Justin, this looks fine to me if Vivek agrees. You did not sign-off on
the patch though, so I can't apply it yet. Please re-send with the ack
from Vivek added and your signed-off-by as well.

-- 
Jens Axboe

