Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1DKXN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:13:57 -0400
Received: from kroah.org ([198.145.64.141]:42928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1DKXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:13:43 -0400
Date: Mon, 11 Apr 2011 16:04:04 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        lkml20101129@newton.leun.net
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Message-ID: <20110411230404.GC32589@kroah.com>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
 <20110401062338.GA6434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401062338.GA6434@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 08:23:38AM +0200, Ingo Molnar wrote:
> 
> * Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > Save cr4 to mmu_cr4_features at boot time
> > 
> > This patch fixes a freeze when resuming from hibernation, introduced by
> > "x86: Cleanup highmap after brk is concluded", commit id
> > e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.
> > This patch should be backported to all the stable tree where the
> > offending commit is present.
> 
> No, the offending commit should be reverted from -stable. It's not at all clear 
> yet why this fix patch helps.

It's now reverted.

thanks,

greg k-h
