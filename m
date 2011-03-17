Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1CQPNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:13:51 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37239 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab1CQPNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:13:49 -0400
X-ASG-Debug-ID: 1300374828-01de284cf87ad50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D822528.1040004@fusionio.com>
Date: Thu, 17 Mar 2011 16:13:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Don't update group weights when on service tree.
References: <1300374357-30686-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH v3] Don't update group weights when on service tree.
In-Reply-To: <1300374357-30686-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300374828
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58168
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-17 16:05, Justin TerAvest wrote:
> Version 3 is updated to apply to for-2.6.39/core.
> 
> For version 2, I took Vivek's advice and made sure we update the group
> weight from cfq_group_service_tree_add().
> 
> If a weight was updated while a group is on the service tree, the
> calculation for the total weight of the service tree can be adjusted
> improperly, which either leads to bad service tree weights, or
> potentially crashes (if total_weight becomes 0).
> 
> This patch defers updates to the weight until a group is off the service
> tree.

Thanks, applied. In the future, please remember to prefix the subject
line with the area of interest. This one should be:

cfq-iosched: bla bla bla

so that people going through the log knows what that patch is touching.
I added it for you here.

-- 
Jens Axboe

