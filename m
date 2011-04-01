Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab1DAVAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:00:34 -0400
Received: from kroah.org ([198.145.64.141]:53027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab1DAVAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:00:33 -0400
Date: Fri, 1 Apr 2011 13:59:39 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        "x86@kernel.org" <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        stable kernel team <stable@kernel.org>
Subject: Re: [stable] [PATCH urgent] x86: Save cr4 to mmu_cr4_features at
 boot time
Message-ID: <20110401205939.GA12759@kroah.com>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
 <20110401062338.GA6434@elte.hu>
 <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
 <20110401190812.GA16830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401190812.GA16830@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 09:08:12PM +0200, Ingo Molnar wrote:
> 
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > P.S.
> >
> > I asked for a backport of e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e to the 
> > stable trees because I forgot to add "CC stable@kernel.org" to the commit 
> > message and this commit is needed to fix a critical crash on boot on xen.
> 
> You are displaying a dangerously amateurish attitude towards quality control 
> and you clealy have no idea what it takes to push fixes into -stable.
> 
> You forwarded a brand-new, visibly dangerous native kernel commit to -stable 
> without Cc:-ing the maintainers and you have caused a native kernel regression 
> that way. You are not maintaining the code in question and you have not 
> committed the patch in question.
> 
> -stable team, please revert this commit. The whole issue obviously needs more 
> testing and we'll forward a proper fix once it's available and tested.

Ok, when I return from vacation on Tuesday I will revert it and do new
releases.

thanks,

greg k-h
