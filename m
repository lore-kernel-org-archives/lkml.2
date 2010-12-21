Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab0LUKdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:33:14 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44641 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab0LUKdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:33:13 -0500
Message-ID: <4D108249.4080205@kernel.dk>
Date: Tue, 21 Dec 2010 11:32:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stefan Schmidt <stefan@datenfreihafen.org>
CC: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/cciss: Close continue statement with semicolon
  to fix build
References: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org> <4D107CF0.5090007@kernel.dk> <20101221103101.GB14097@excalibur.local>
In-Reply-To: <20101221103101.GB14097@excalibur.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 11:31, Stefan Schmidt wrote:
> Hello.
> 
> On Tue, 2010-12-21 at 11:09, Jens Axboe wrote:
>> On 2010-12-21 10:42, Stefan Schmidt wrote:
>>> This fixes the following build error:
>>> drivers/block/cciss.c: In function ‘cciss_revalidate’:
>>> drivers/block/cciss.c:2839: error: expected ‘;’ before ‘if’
>>> make[2]: *** [drivers/block/cciss.o] Error 1
>>
>> It's already included in Linus' git.
> 
> Hmm, not on my latest pull. And git tells me I'm up-to-date.
> 
> commit 8cad7f06e3b1d3f9a28bb7385e8fc09d5e1bf84c
> Merge: 92d7c9b 0e4d413
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Dec 20 10:35:04 2010 -0800
> 
>     Merge branch 'v4l_for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
> 
> Webfrontend tells me the same.
> 
> So it is either not mirrored out yet or something else is spuky.

Latest head is:

commit e5fcdb7ed856b714c878ad470040fe832cbe462b
Merge: 7bddaac 093d804
Author: Linus Torvalds <torvalds@linux-foundation.org>

And the fix is commit 453434cf3fdcd3954bb52460e37d4945a0913d3e. Perhaps
the mirror is slow, dunno, I pull via ssh from master.

-- 
Jens Axboe

