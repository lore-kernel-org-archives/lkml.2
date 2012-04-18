Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2DRXMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:12:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24144 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DRXME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:12:04 -0400
Date: Thu, 19 Apr 2012 01:12:03 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: anirudh bhat <abhat38@gmail.com>
cc: arve@android.com, dhowells@redhat.com, chris+android@zenthought.org,
        hpa@zytor.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging:android:fix line over 80 characters issue
 in binders.c this patch fixes line over 80 characters warning that was found
 using checkpatch.pl tool Signed-off-by:Anirudh Bhat <abhat38@gmail.com>
In-Reply-To: <alpine.LNX.2.00.1204190026110.14916@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204190109200.14916@swampdragon.chaosbits.net>
References: <1334769639-5914-1-git-send-email-abhat38@gmail.com> <alpine.LNX.2.00.1204190026110.14916@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Jesper Juhl wrote:

> On Wed, 18 Apr 2012, anirudh bhat wrote:
> 
> > From: anirudh bhat <anirudhbhat@ubuntu.ubuntu-domain>
> > 
> Unless you are sending a patch on behalf of someone else, and need to 
> preserve that person as the author of the patch, there's usually no need 
> for a From: in the body of your patch submission email - the From: from 
> the email headers will be used.
> 

Ohh and I forgot to mention, that in case you do put a From: line (or any 
other) you want to use a *real* email address.

The same goes for the email Cc: list - "anirudhbhat@ubuntu.ubuntu-domain" 
doesn't work so great there either, yet that is one of the addresses you 
Cc'ed the original mail to..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

