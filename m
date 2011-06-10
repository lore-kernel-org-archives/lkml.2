Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1FJJTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:19:46 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:35840 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1FJJTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:19:43 -0400
X-ASG-Debug-ID: 1307697582-01de280c1e40ea0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DF1E1B0.2090907@fusionio.com>
Date: Fri, 10 Jun 2011 11:19:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/7] tmpfs: clone shmem_file_splice_read
References: <alpine.LSU.2.00.1106091529060.2200@sister.anvils> <alpine.LSU.2.00.1106091531120.2200@sister.anvils>
X-ASG-Orig-Subj: Re: [PATCH 1/7] tmpfs: clone shmem_file_splice_read
In-Reply-To: <alpine.LSU.2.00.1106091531120.2200@sister.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307697582
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65963
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-10 00:32, Hugh Dickins wrote:
> Copy __generic_file_splice_read() and generic_file_splice_read()
> from fs/splice.c to shmem_file_splice_read() in mm/shmem.c.  Make
> page_cache_pipe_buf_ops and spd_release_page() accessible to it.

That's a lot of fairly complicated and convoluted code to have
duplicated. Yes, I know I know, it's already largely duplicated from the
normal file read, but still... Really no easy way to share this?

-- 
Jens Axboe

