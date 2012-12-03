Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2LCHvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:51:19 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51496 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2LCHvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:51:18 -0500
Date: Mon, 3 Dec 2012 08:51:11 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Vitalii Demianets <vitas@nppfactor.kiev.ua>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121203075110.GC7723@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
 <CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
 <201211291822.16565.vitas@nppfactor.kiev.ua>
 <201211291836.59358.vitas@nppfactor.kiev.ua>
 <20121129235822.GA2590@local>
 <CAM3j68rH8qyN8zX7TLZNvQz-1Vr6qMjS0cR7QKGAs6w54L7dag@mail.gmail.com>
 <20121130213333.GA2603@local>
 <CAM3j68qHuqeafMjfpCiuRKLsKk+ZE3f=DuTM4zmHwUZdHULBMQ@mail.gmail.com>
 <20121201035625.GC2603@local>
 <20121201095831.GA18966@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121201095831.GA18966@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 09:58:32AM +0000, Cong Ding wrote:
> If it is really necessary to save the 4 lines of codes, I would suggest to do 
> in the following style. But you are more senior than me, so I may be wrong in 
> this aspect. 

"Seniority" (whatever you mean by that) has got nothing to do with it.
I'll accept any child's patch if it is good. Discussing code on LKML is
a purely technically thing, only if two patches are technically equivalent,
the maintainer's personal taste will decide. And if it makes you feel better:
My patches (and those of any other developer) are also sometimes rejected
because they are not to some other maintainer's taste.

Thanks,
Hans
