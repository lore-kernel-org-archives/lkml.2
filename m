Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0K3Pix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:38:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0K3Piv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:38:51 -0500
Date: Tue, 30 Nov 2010 10:38:39 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101130153839.GM15818@bombadil.infradead.org>
References: <20101022012302.GA7487@havoc.gtf.org>
 <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF506A6.4020200@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 03:13:58PM +0100, Tejun Heo wrote:
> > Tejun, any ideas how I can debug this?
> 
> Hmm... DIPM commands are failing with AC_ERR_OTHER.  Other than DIPM
> not being configured and speed capped at 1.5Gbps, the machine works
> fine afterwards, right?  Are you up for applying debug patches?
> 

Yup, it's chugging along happily, though I notice kernel builds are
taking a minute or two longer (but I don't bother to time them so it's
purely subjective.)

Be happy to apply any debug patches, but I plan on replacing the drive
with a faster one at some point in the next few weeks.

--Kyle
