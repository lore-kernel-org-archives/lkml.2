Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1F0HDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:03:43 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:39912 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab1F0HBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:01:21 -0400
X-ASG-Debug-ID: 1309158080-03d6a510a6baf70001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E082ABC.5070106@fusionio.com>
Date: Mon, 27 Jun 2011 09:01:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]cfq-iosched: make code consistent
References: <1309157560.15392.177.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch 2/2]cfq-iosched: make code consistent
In-Reply-To: <1309157560.15392.177.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1309158080
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.67251
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-27 08:52, Shaohua Li wrote:
> ioc->ioc_data is rcu protectd, so uses correct API to access it.
> This doesn't change any behavior, but just make code consistent.

Thanks, applied both of these.

-- 
Jens Axboe

