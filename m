Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1IBXHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:07:15 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:53940 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab1IBXHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:07:12 -0400
X-ASG-Debug-ID: 1315004831-01de285e7b0a520001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E61619E.8040105@fusionio.com>
Date: Fri, 2 Sep 2011 17:07:10 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
References: <1315004059-9844-1-git-send-email-jack@suse.cz>
X-ASG-Orig-Subj: Re: [PATCH 0/2 v3] Small cleanup of bdi_forker_thread()
In-Reply-To: <1315004059-9844-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1315004831
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.73470
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-02 16:54, Jan Kara wrote:
> 
>   Hi Jens,
> 
>   so after I realized how I underestimated subtlety of bdi_forker_thread()
> here are two small cleanups to it. The first one puts clearing of BDI_pending
> in a more natural place, the second patch adds a comment so that fools like
> me don't try to optimize the function in a wrong place...

Thanks Jan, I've queued it up for 3.1. I've marked it as stable, looks
like we need it from 2.6.36 and above.

-- 
Jens Axboe

