Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0E3VOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 17:14:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab0E3VOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 17:14:49 -0400
Date: Sun, 30 May 2010 14:11:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.35-rc1
Message-ID: <alpine.LFD.2.00.1005301356350.3986@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been two weeks, and so the merge window is closed. There may be a few 
trees I haven't pulled yet, but the bulk should all be there. And please, 
let's try to make the merge window mean something this time - don't send 
me any new pull request unless they are for real regressions or for major 
bugs, ok?

This time, there are no new filesystems (surprise surprise), but there's 
certainly been filesystem work both on an individual FS layer (btrfs, 
cept, cifs, ext4, nfs, ocfs2 and xfs) and at the VFS layer (superblock 
and quota cleanups in particular).

But as usual, the bulk of the changes are in drivers. About two thirds of 
all the changes, to be exact. infiniband, networking and staging drivers 
are the bulk of it, but there's changes all over (drm, sound, media, usb, 
input layer, you name it).

And what's good to see is that we continue to have very healthy 
statistics. About 8500 commits (of which 400+ are merges), with about a 
thousand individual developers involved (git counts 1047, but some of them 
are bound to be duplicates due to people mis-spelling their names etc). 
It's skewed, of course - with the median number of commits per person 
being just three - but I think that's what we want to see in a healthy 
development environment.

			Linus
