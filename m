Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2CPVEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:04:52 -0400
Received: from science.horizon.com ([71.41.210.146]:24073 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757840Ab2CPVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:04:48 -0400
Date: 16 Mar 2012 17:04:46 -0400
Message-ID: <20120316210446.2198.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jkosina@suse.cz, linux@horizon.com
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
In-Reply-To: <alpine.LNX.2.00.1203161623130.18356@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So it might be the culprit. As the reason of the corruption is not yet 
> understood, it might be that suspend/resume cycle is not necessary 
> pre-requisite for this to trigger, it might just make it more likely.

It might just be virtual console switching.  Normally I live in X,
but I might have switched to a text console for some reason (I don't
specifically remember doing this, but it's very plausible for me).

> And the corruption is observed to be indeed several writes of 0x00000000, 
> so it could easily lead to null pointer dereferences all over the place.
> 
> Are you able to reproduce the problem if you turn kernel modesetting off?

Unfortunately, this is the only time it's happened to me with kernel
modesetting *on*.  Would repeated checksums of a kernel tree be a good
way to detect random memory stomping?
