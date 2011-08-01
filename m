Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1HAIcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:32:04 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:47751 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1HAIbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:31:55 -0400
X-ASG-Debug-ID: 1312187508-01de280c1e10a0d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E366473.5050909@fusionio.com>
Date: Mon, 1 Aug 2011 10:31:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH]blk-throttle: correctly determine sync bio
References: <1312184397.15392.430.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH]blk-throttle: correctly determine sync bio
In-Reply-To: <1312184397.15392.430.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312187508
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70577
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-01 09:39, Shaohua Li wrote:
> read request is always sync. Using rw_is_sync() to determine
> if a bio is sync.

Thanks, good catch. Applied.

-- 
Jens Axboe

