Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1CBX5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:57:43 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:51381 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab1CBX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:57:42 -0500
X-ASG-Debug-ID: 1299110260-01de280c53128700001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D6ED971.7040305@fusionio.com>
Date: Wed, 2 Mar 2011 18:57:37 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>
Subject: Re: [PATCH 0/3] block: Few fixes for throttle and blk_cleanup_queue()
References: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 0/3] block: Few fixes for throttle and blk_cleanup_queue()
In-Reply-To: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299110260
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.56879
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-28 14:25, Vivek Goyal wrote:
> Hi Jens,
> 
> These are few fixes for block throtl code and for blk_cleanup_queue(). These
> should be a good candidate for 2.6.39.

They look good, thanks.

A small please to revisit your changelog style. Lets drop the bullet
points, and it's best to keep at eg 72 chars so that the output is
readable in git log easily. I sometimes change these for you, would be
nice if they followed normal style though.


-- 
Jens Axboe

