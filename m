Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161451Ab2COUzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:55:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11234 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031514Ab2COUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:55:17 -0400
Date: Thu, 15 Mar 2012 21:54:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        =?EUC-KR?B?x9S47cHW?= <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] power, max8998: Include linux/module.h just once in
 drivers/power/max8998_charger.c
In-Reply-To: <4F623ED3.1050003@windriver.com>
Message-ID: <alpine.LNX.2.00.1203152153530.18680@swampdragon.chaosbits.net>
References: <32079635.330331328493473417.JavaMail.weblogic@epml22> <20120315171700.GE11441@oksana.dev.rtsoft.ru> <4F623ED3.1050003@windriver.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-623470521-1331844853=:18680"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-623470521-1331844853=:18680
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 15 Mar 2012, Paul Gortmaker wrote:

> On 12-03-15 01:17 PM, Anton Vorontsov wrote:
> > On Mon, Feb 06, 2012 at 01:57:54AM +0000, 함명주 wrote:
> >>> Remove the duplicate.
> >>>
> >>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >>
> >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > 
> > Applied, thanks!
> 
> There is already a commit queued in linux-next that deletes
> all the duplicates at once.  It just so happens to delete
> the other instance vs the one shown here.  So if both
> commits are present, then there won't be *any* module.h
> left, and the build will fail.  If it is possible, please
> just drop this patch, since the treewide duplicate patch
> will still have to exist to fix the other instances.
> 
> https://lkml.org/lkml/2012/2/29/586
> 

I agree. Drop this one.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-623470521-1331844853=:18680--
