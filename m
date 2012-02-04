Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2BDEfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 23:35:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2BDEfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 23:35:44 -0500
Date: Fri, 3 Feb 2012 20:36:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: xi.wang@gmail.com, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, haogangchen@gmail.com
Subject: Re: [PATCH] nilfs2: avoid overflowing segment numbers in
 nilfs_ioctl_clean_segments()
Message-Id: <20120203203605.da735392.akpm@linux-foundation.org>
In-Reply-To: <20120204.121302.227986518.ryusuke@osrg.net>
References: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
	<20120204.121302.227986518.ryusuke@osrg.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Feb 2012 12:13:02 +0900 (JST) Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> On Fri,  3 Feb 2012 10:26:07 -0500, Xi Wang wrote:
> > nsegs is read from userspace.  Limit its value and avoid overflowing
> > nsegs * sizeof(__u64) in the subsequent call to memdup_user().
> > 
> > This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.
> > 
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Cc: Haogang Chen <haogangchen@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  fs/nilfs2/ioctl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> 
> 
> Thank you for posting this fix.
> 
> Andrew, could you send this uptream in this cycle ?

I sure can.
