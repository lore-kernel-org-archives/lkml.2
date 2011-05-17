Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1EQUW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:22:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56861 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab1EQUW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:22:27 -0400
Date: Tue, 17 May 2011 22:22:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/3 v2.6.39-rc7] block: make
 disk_block_events() properly wait for work cancellation
Message-ID: <20110517202224.GA371@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sitsofe Wheeler <sitsofe@yahoo.com>, Meelis Roos <mroos@linux.ee>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <20110517154748.GS20624@htj.dyndns.org>
 <4DD2CDE2.60604@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DD2CDE2.60604@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 09:34:58PM +0200, Jens Axboe wrote:
> BTW, this is patch 3/3, not 2/3. Had me confused for a while, the
> numbering on the initial series was off as well.

Same here, they don't apply cleanly for some reason on latest Linus
tree. I'm testing your #for-linus branch now, instead.

Thanks.

-- 
Regards/Gruss,
    Boris.
