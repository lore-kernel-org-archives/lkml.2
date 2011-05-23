Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1EWRgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:36:07 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:50185 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab1EWRgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:36:05 -0400
X-ASG-Debug-ID: 1306172163-01de28096b5bd10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDA9AFF.3080400@fusionio.com>
Date: Mon, 23 May 2011 19:35:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] blk-cgroup: Initialize ioc->cgroup_changed at ioc creation
  time
References: <20110523145539.GA4019@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-cgroup: Initialize ioc->cgroup_changed at ioc creation
  time
In-Reply-To: <20110523145539.GA4019@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306172163
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64593
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-23 16:55, Vivek Goyal wrote:
> If we don't explicitly initialize it to zero, CFQ might think that
> cgroup of ioc has changed and it generates lots of unnecessary calls
> to call_for_each_cic(changed_cgroup). Fix it.
> 
> cfq_get_io_context()
>   cfq_ioc_set_cgroup()
>      call_for_each_cic(ioc, changed_cgroup)

Thanks Vivek, applied.

-- 
Jens Axboe

