Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab0J1McR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:32:17 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:51630 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0J1McP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:32:15 -0400
X-ASG-Debug-ID: 1288269133-08b7c8ea0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC96D4A.7060000@fusionio.com>
Date: Thu, 28 Oct 2010 06:32:10 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mike Miller <mike.miller@hp.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: cciss: fix information leak to userland
References: <1288194048-9233-1-git-send-email-segooon@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] block: cciss: fix information leak to userland
In-Reply-To: <1288194048-9233-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1288269133
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44980
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-27 09:40, Vasiliy Kulikov wrote:
> Structure IOCTL_Command_struct is copied to userland with
> some padding fields at the end of the struct unitialized.
> It leads to leaking of contents of kernel stack memory.

Thanks, applied.


-- 
Jens Axboe

