Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab0HJQRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:17:31 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:55963 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab0HJQR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:17:26 -0400
X-ASG-Debug-ID: 1281457045-189700880000-xx1T2L
X-Barracuda-URL: http://10.101.1.180:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C617B9D.5060508@fusionio.com>
Date: Tue, 10 Aug 2010 12:17:33 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [GIT PULL #2] block bits for 2.6.36-rc1
Subject: Re: [GIT PULL #2] block bits for 2.6.36-rc1
References: <4C5FF80A.9040101@fusionio.com>
In-Reply-To: <4C5FF80A.9040101@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281457045
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 08:43 AM, Jens Axboe wrote:
> Hi Linus,
> 
> So lets try this for real. It appears to work fine, on the laptop
> and running tests on a box back home. At the very end is the fixup
> patch for merging.

Tests back home completed successfully. I added a patch for
fixing a compile issue with !CONFIG_BLOCK, so the updated diffstat
now looks like this:

 154 files changed, 4285 insertions(+), 3224 deletions(-)

> Please pull!
> 
>   git://git.kernel.dk/linux-2.6-block.git for-2.6.36

Thanks.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
