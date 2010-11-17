Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0KPX6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:58:06 -0500
Received: from cobra.newdream.net ([66.33.216.30]:40785 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab0KPX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:58:00 -0500
Date: Tue, 16 Nov 2010 16:02:02 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ceph tree
In-Reply-To: <20101117104314.56aeb069.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1011161558180.1702@cobra.newdream.net>
References: <20101117104314.56aeb069.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Stephen Rothwell wrote:
> Hi Sage,
> 
> After merging the ceph tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "ceph_str_hash" [fs/ceph/ceph.ko] undefined!
> 
> Caused by commit 5f69106b3f68be20015d1d8a43192bc2f14c7046 ("ceph: add
> dir_layout to inode").
> 
> I have used the ceph tree from next-20101116 for today.

I've added the missing EXPORT_SYMBOL and pushed a new for-next.

Thanks!
sage
