Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0G0Sfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:35:47 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54943 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753284Ab0G0Sfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:35:45 -0400
Subject: Re: linux-next: Tree for July 27
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100727160708.722c39c1.sfr@canb.auug.org.au>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:35:43 -0500
Message-ID: <1280255743.2002.184.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2010 18:35:44.0400 (UTC) FILETIME=[85E90900:01CB2DBA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 16:07 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100726:
> 
> The arm tree lost its conflict.
> 
> The microblaze tree lost its conflict.
> 
> The mips tree gained a build failure so I used the version from
> next-20100726.
> 
> The xfs tree still has its build failure so I used the version from
> next-20100723.

The XFS master branch has been updated.  It includes
a fix for the problem caused by this commit:

    0fd7275cc42ab734eaa1a2c747e65479bd1e42af

...which was is the cause of this linux-next build failure.

The branch has also been re-based to 2.6.35-rc6.

					-Alex


