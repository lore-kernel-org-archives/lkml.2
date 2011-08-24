Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab1HXN7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:59:33 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:35449 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1HXN7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:59:31 -0400
X-ASG-Debug-ID: 1314194370-01de2846171c910001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E5503C0.2030005@fusionio.com>
Date: Wed, 24 Aug 2011 15:59:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]block: simplify force plug flush code a little bit
References: <1314176130.29510.35.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch 2/2]block: simplify force plug flush code a little bit
In-Reply-To: <1314176130.29510.35.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314194370
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72696
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-24 10:55, Shaohua Li wrote:
> Cleaning up the code a little bit. attempt_plug_merge() traverses the plug
> list anyway, we can do the request counting there, so stack size is reduced
> a little bit.
> The motivation here is I suspect if we should count the requests for each
> queue (task could handle multiple disks in the meantime), but my test doesn't
> show it's worthy doing. If somebody proves we should do it, below change
> will make that more easier.

Good change, applied.

-- 
Jens Axboe

