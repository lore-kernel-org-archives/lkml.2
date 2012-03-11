Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2CKRKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:10:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53383 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2CKRKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:10:49 -0400
Date: Sun, 11 Mar 2012 10:10:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James <angweiyang@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>
Subject: Re: [ 01/95] ARM: OMAP: make iommu subsys_initcall to fix builtin
 omap3isp
Message-ID: <20120311171044.GB24440@kroah.com>
References: <20120309194424.GA2134@kroah.com>
 <20120309190202.425318888@linuxfoundation.org>
 <CAK=WgbZs-p=g6tXKNTOt2n8r4HHe-Td_iW3n2k5k2-mhZ6VkTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK=WgbZs-p=g6tXKNTOt2n8r4HHe-Td_iW3n2k5k2-mhZ6VkTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 02:47:41PM +0200, Ohad Ben-Cohen wrote:
> Hi Greg,
> 
> On Fri, Mar 9, 2012 at 9:02 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ohad Ben-Cohen <ohad@wizery.com>
> >
> > commit 435792d93410f008120c4dbab148019a3cc31dbc upstream.
> 
> Can you please also take commit 134d12f "ARM: OMAP: fix iommu, not mailbox" ?
> 
> commit 435792d "ARM: OMAP: make iommu subsys_initcall to fix builtin
> omap3isp" had a typo, which was fixed by 134d12f "ARM: OMAP: fix
> iommu, not mailbox" (and the latter wasn't flagged for stable, sorry).

Ok, I'll queue this up, thanks for letting me know.

greg k-h
