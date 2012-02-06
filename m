Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2BFGMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:12:00 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64058 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab2BFGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:11:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMFAFxuL095LD+b/2dsb2JhbAA9BoULqG2BPoEGgXIBAQUjDwEjIxAIAw4KAgImAgIUJQMhEQKvNpEuE4EchzkDgnkBBQICHQQGAQsBCAUDAwkGBA8DAwGEHQEDAQQegiMzYwSVJ4kwiUAp
Date: Mon, 6 Feb 2012 17:11:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kmemleak report 1/2] kernel 3.1.6, x86_64: mm, xfs ?, vfs ?
Message-ID: <20120206061156.GA12836@dastard>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
 <20120115223701.GA3937@mobil.systemanalysen.net>
 <20120120000800.GA24762@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120120000800.GA24762@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 01:08:00AM +0100, Roland Eggner wrote:
> With kernel 3.1.6 + cherry-picked “kmemleak: Handle percpu memory allocation” as
> suggested by Catalin Marinas, I get no significant changes to kmemleak reports,
> and e.g. following /proc/meminfo snapshots.  I wonder, is such a huge slab
> memory normal?  Is there anything else suspicious?

Having 200k inodes in memory when you have 20+ filesystems is
not unusual.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
