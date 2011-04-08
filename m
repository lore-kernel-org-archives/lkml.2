Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab1DHWzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:55:13 -0400
Received: from infernal.debian.net ([87.230.26.131]:44974 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1DHWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:55:09 -0400
Date: Sat, 9 Apr 2011 00:55:04 +0200
From: Andreas Bombe <andreas.bombe@mytum.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOPS procfs in vma_stop() from bad vma pointer
Message-ID: <20110408225503.GA4633@amos.fritz.box>
References: <20110407002832.GA5185@amos.fritz.box>
 <20110407165355.37af12b0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407165355.37af12b0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 04:53:55PM -0700, Randy Dunlap wrote:
> -13 == -EACCES.  Could come from m_start() calling mm_for_maps().
> m_start() handles IS_ERR(mm).  m_stop() handles IS_ERR(vma).
> But m_next() does not handle IS_ERR(vma).  I wonder if it needs to do that.
> 
> Duh.  Try latest git with this patch:

Thanks, Anca Emanuel already told me in private mail (I didn't notice
that it didn't go to lkml) that it was fixed already. Sorry for the
noise.

-- 
Andreas Bombe
