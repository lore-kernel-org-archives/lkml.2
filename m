Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab1GHCxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 22:53:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1GHCxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 22:53:40 -0400
Date: Thu, 7 Jul 2011 19:53:33 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [000/107] 2.6.39.3 review
Message-ID: <20110708025333.GA12676@suse.de>
References: <20110708001740.GA14031@kroah.com>
 <201107080406.26686.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107080406.26686.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 04:06:24AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 08 July 2011, Greg KH wrote:
> [...]
> > Responses should be made by Sat, Jul 9, 2011, 00:00:00 UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.3-rc1.gz
> > and the diffstat can be found below.
> 
> The patch series from queue-2.6.39[1] (a) and patch-2.6.39.3-rc1.gz (b)
> differ, leading to a build failure due to gss_krb5_enctypes.h missing 
> from patch-2.6.39.3-rc1.gz

Ok, after the mirrors catch up, there will be a -rc2 at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.3-rc2.gz
that should have solved this issue.

thanks again for pointing it out.

greg k-h
