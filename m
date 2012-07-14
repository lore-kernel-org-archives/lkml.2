Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2GNXX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 19:23:26 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:16573 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2GNXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 19:23:19 -0400
Date: Sun, 15 Jul 2012 01:23:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Silva Paulo <psdasilva@yahoo.com>
cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Small bug: Wrong return check from idr_pre_get in loop.c
In-Reply-To: <1342232813.26165.YahooMailNeo@web112006.mail.gq1.yahoo.com>
Message-ID: <alpine.LNX.2.00.1207150117530.13006@swampdragon.chaosbits.net>
References: <1342232813.26165.YahooMailNeo@web112006.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Silva Paulo wrote:

> idr_pre_get never returns a value < 0. It returns 0 (no memory) or 1 (OK).
> 
Please read Documentation/SubmittingPatches

In summary:
 - you are missing a Signed-off-by: line.
 - there is no diffstat.
 - the patch is an attachment, not inline in the email.
 - the recipients list of the email could be improved (see below).

If you had used scripts/get_maintainer.pl on your patch you'd have gotten 
a better list of recipients for your patch mail:
  $ scripts/get_maintainer.pl My_linux-3.5-rc6_patches
  Jens Axboe <axboe@kernel.dk> (commit_signer:15/17=88%)
  Andrew Morton <akpm@linux-foundation.org> (commit_signer:6/17=35%)
  Kay Sievers <kay.sievers@vrfy.org> (commit_signer:5/17=29%)
  Jeff Moyer <jmoyer@redhat.com> (commit_signer:2/17=12%)
  Dmitry Monakhov <dmonakhov@openvz.org> (commit_signer:2/17=12%)
  linux-kernel@vger.kernel.org (open list)

Please try again.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

