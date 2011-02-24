Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1BXELN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:11:13 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:34910 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab1BXELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:11:12 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH] Unlock vfsmount_lock in do_mount
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20110224011057.GP22723@ZenIV.linux.org.uk>
References: <1298447989-12107-1-git-send-email-hooanon05@yahoo.co.jp> <20110224011057.GP22723@ZenIV.linux.org.uk>
Date: Thu, 24 Feb 2011 13:11:06 +0900
Message-ID: <6152.1298520666@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> On Wed, Feb 23, 2011 at 04:59:49PM +0900, J. R. Okajima wrote:
> > By the commit
> > 	b3e19d9 2011-01-07 fs: scale mntget/mntput
> > vfsmount_lock was introduced around testing mnt_count.
> > Fix the mis-typed 'unlock'
>
> Gyah...  Nice catch.   Applied, will push tonight.

Thanks.
But I made a mistake in the subject.
It should be "do_umount" instead of "do_mount". Please fix it when you
push. Otherwise I will post the fixed one.


J. R. Okajima
