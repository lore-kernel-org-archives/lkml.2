Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1GHGRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:17:35 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:53828 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1GHGRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:17:33 -0400
X-ASG-Debug-ID: 1310105853-03d6a510a9130440001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E16A0FA.4000009@fusionio.com>
Date: Fri, 8 Jul 2011 08:17:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: document blk_plug list access
References: <1310090369.15392.264.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch]block: document blk_plug list access
In-Reply-To: <1310090369.15392.264.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310105853
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68297
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-08 03:59, Shaohua Li wrote:
> I'm often confused why not disable preempt when changing blk_plug list. It
> would be better to add comments here in case others have the similar concerns.

Sure, I'll add this.

-- 
Jens Axboe

