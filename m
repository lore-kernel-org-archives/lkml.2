Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab2IFAOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:14:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40990 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab2IFAOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:14:53 -0400
Date: Wed, 5 Sep 2012 17:14:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [PATCH] pch_uart: Add eg20t_port lock field, avoid recursive
 spinlocks
Message-ID: <20120906001448.GA7278@kroah.com>
References: <422aa2054659680fb138d2153dcc852b2620b04d.1346889148.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <422aa2054659680fb138d2153dcc852b2620b04d.1346889148.git.dvhart@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:04:07PM -0700, Darren Hart wrote:
> The following patch has been included in linux-next
> (fe89def79c48e2149abdd1e816523e69a9067191) but has not yet landed in mainline
> nor been queued for stable so far as I can determine. This patch addresses a
> deadlock in mainline and is a prerequisite for an additional fix required by the
> PREEMPT_RT kernel. Can we get this pulled into 3.4.11 please?

3.4.11?  It has to hit Linus's tree first.

> Perhaps I am
> jumping the gun, but this patch was originally pulled on June 19, 2012.

Remember, we missed a pull cycle for tty due to other problems, I
thought I picked all of the different pieces needed for 3.6, but I must
of missed this one.  Should it go there now?  Also, if you want a patch
in the stable tree, please tell me when you submit it by marking it with
a
	cc: stable <stable@vger.kernel.org>
in the signed-off-by area of the patch.

thanks,

greg k-h
