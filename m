Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab0KPBQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:16:12 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:41577 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754415Ab0KPBQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:16:11 -0500
Date: Tue, 16 Nov 2010 12:16:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101116011606.GH22876@dastard>
References: <20101111125219.GA945@bitwizard.nl>
 <20101115023932.GD22876@dastard>
 <20101115074241.GH16758@myhost.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115074241.GH16758@myhost.felk.cvut.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 08:42:41AM +0100, Michal Svoboda wrote:
> Dave Chinner wrote:
> > Depending on the kernel, sync will keep writing if you keep
> > dirtying. This should be mostly fixed in 2.6.36....
> 
> Is that a "we hope that it is so but we are not sure" kind of "mostly",
> or a "there are known cases when this is not true" one?

The latter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
