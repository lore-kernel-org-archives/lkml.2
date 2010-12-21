Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0LUKbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:31:09 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:60096 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933627Ab0LUKbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:31:08 -0500
Date: Tue, 21 Dec 2010 11:31:01 +0100
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Message-ID: <20101221103101.GB14097@excalibur.local>
References: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org>
 <4D107CF0.5090007@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D107CF0.5090007@kernel.dk>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: [PATCH] block/cciss: Close continue statement with semicolon
 to fix build
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Tue, 2010-12-21 at 11:09, Jens Axboe wrote:
> On 2010-12-21 10:42, Stefan Schmidt wrote:
> > This fixes the following build error:
> > drivers/block/cciss.c: In function ‘cciss_revalidate’:
> > drivers/block/cciss.c:2839: error: expected ‘;’ before ‘if’
> > make[2]: *** [drivers/block/cciss.o] Error 1
> 
> It's already included in Linus' git.

Hmm, not on my latest pull. And git tells me I'm up-to-date.

commit 8cad7f06e3b1d3f9a28bb7385e8fc09d5e1bf84c
Merge: 92d7c9b 0e4d413
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Dec 20 10:35:04 2010 -0800

    Merge branch 'v4l_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6

Webfrontend tells me the same.

So it is either not mirrored out yet or something else is spuky.

regards
Stefan Schmidt
