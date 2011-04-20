Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1DTUMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:12:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48934 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab1DTUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:12:31 -0400
Date: Wed, 20 Apr 2011 22:12:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110420201225.GA29947@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110414202445.GA6173@liondog.tnic>
 <BANLkTi=h+NL+qqMDBNvOUmVDonORf4Qx2A@mail.gmail.com>
 <20110415041455.GA27928@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110415041455.GA27928@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:14:55AM -0400, Christoph Hellwig wrote:
> Jens already has a fix in his tree to always offload the block I/O
> submission to blockd for this case.

FWIW, I can't trigger the warning with 2.6.39-rc4-00089-g2f666bc
anymore. So either Jens' fixes have trickled up to Linus or it is due to
6631e635c65d he mentioned earlier.

Thanks.

-- 
Regards/Gruss,
    Boris.
