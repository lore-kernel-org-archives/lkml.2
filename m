Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1KXIyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:54:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36910 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1KXIys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:54:48 -0500
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
From: Sasha Levin <levinsasha928@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
In-Reply-To: <4e3c37a6-3777-4138-800b-f055f7caa8f3@email.android.com>
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
	 <4e3c37a6-3777-4138-800b-f055f7caa8f3@email.android.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 24 Nov 2011 10:54:41 +0200
Message-ID: <1322124881.4248.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 08:49 +0000, Jonathan Cameron wrote:
> 
> Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> >The error was introduced in commit b4641336 ("iio: fix a leak due to
> >improper use of anon_inode_getfd()").
> >
> >Looks like the code wasn't even compile tested. Instead of just fixing
> >the
> >error I changed the function a bit to make it nicer.
> Minimal change would have been slightly nicer but clean up is obvious so fine. Thanks for doing this.  Andrew m has a dirty build fix in NM but he will drop that when this hits.

If you'd like I can split it into two patches, the fix and the cleanup.

-- 

Sasha.

