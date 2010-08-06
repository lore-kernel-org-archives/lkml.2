Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab0HFKmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:42:17 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37316 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047Ab0HFKmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:42:12 -0400
X-ASG-Debug-ID: 1281091331-49cd00030000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5BE701.1020800@fusionio.com>
Date: Fri, 6 Aug 2010 12:42:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
References: <4C5BE640.2050801@fusionio.com>
In-Reply-To: <4C5BE640.2050801@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281091331
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-06 12:38, Jens Axboe wrote:
> Hi Linus,
> 
> This is the big round of updates for the IO bits for 2.6.36-rc1.
> Not sure what happened on the excessive number of merges listed
> as:
> 
>       Merge branch 'for-2.6.36' into for-next
> 
> as these should 1) just have been regular fast forwards, and 2)
> not be listed under 2.6.36 when the pull was in the other
> direction. I tend to run -git git versions, so perhaps there
> was a bad version in there. I was planning on reshuffling
> the branch, but it's 3 months of churn and fixups in there and
> that would take me a while. Let me know if you absolutely
> hate it and I'll do it.

Oh, and the 'master' merges into for-2.6.36 were all done to
resolve conflicts. I had to do two just this week after you
starting pulling in changes from others, as they were beyond
git to automatically resolve. So there are no excessive merges,
just the weird listings for for-2.6.36 -> for-next.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
