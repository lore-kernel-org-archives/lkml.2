Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1EFVT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:19:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43471 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1EFVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:19:28 -0400
Date: Fri, 6 May 2011 23:19:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, arnd@arndb.de
Subject: Re: Remove last BKL leftover: lock_depth
Message-ID: <20110506211925.GA20111@one.firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org> <20110506141114.10795803.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506141114.10795803.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 02:11:14PM -0700, Andrew Morton wrote:
> On Fri,  6 May 2011 14:05:24 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I noticed the BKL task->lock_depth field was there with various users.
> > But they all don't need it anymore because the BKL is gone.
> > Fix up all the users and then finally remove the field.
> > 
> > This patchkit only removes code.
> 
> Patches in Ingo's tree from Jon Corbet have done this removal.

Ok thanks.  I was wondering why noone had done it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
