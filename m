Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2LSSre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:47:34 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33417 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LSSr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:47:28 -0500
Date: Wed, 19 Dec 2012 10:47:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at block/genhd.c:1574 disk_clear_events()
Message-ID: <20121219184721.GS1844@htj.dyndns.org>
References: <20121219095241.GA27310@localhost>
 <20121219095632.GA27488@localhost>
 <50D1E4EB.6000200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D1E4EB.6000200@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha, Fengguang.

On Wed, Dec 19, 2012 at 11:01:47AM -0500, Sasha Levin wrote:
> I'm slightly confused here: afaik what you're testing is Linus's git HEAD, right? (I
> got that from 3.7.0-01930-gbff6343).

Nope, Fengguang is basically testing every branch published to
git.kernel.org.

> Tejun stated that he queued that commit for 3.9, and indeed I don't see it in Linus's
> master as of today.

And it won't appear till 3.9-rc1.

> Therefore, I'm not quite sure how you're hitting it in your bisection - the only place
> that commit is supposed to be at is in Tejun's -next/linux-next trees.

It will appear in next soon.

Thanks.

-- 
tejun
