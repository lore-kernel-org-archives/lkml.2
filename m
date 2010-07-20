Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab0GTTId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:08:33 -0400
Received: from kroah.org ([198.145.64.141]:38371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab0GTTId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:08:33 -0400
Date: Tue, 20 Jul 2010 12:08:26 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci/mrst: add extra check in fixed bar detection
Message-ID: <20100720190826.GA16162@kroah.com>
References: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <4C45DA7F.1060801@candelatech.com>
 <4C45DC30.5000308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C45DC30.5000308@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 10:26:08AM -0700, H. Peter Anvin wrote:
> On 07/20/2010 10:18 AM, Ben Greear wrote:
> > On 07/16/2010 11:58 AM, Jacob Pan wrote:
> >> Fixed bar capability structure is searched in PCI extended configuration
> >> space. We need to make sure there is a valid capability id to begin with
> >> otherwise, the search code may stuck in a infinite loop which results in
> >> boot hang.
> >> This patch adds additional check for cap ID 0, which is also invalid.
> > 
> > I think this should be added to the stable tree for 2.6.34
> > as well...
> > 
> 
> Agreed. Greg, could you consider upstream
> f82c3d71d6fd2e6a3e3416f09099e29087e39abf for -stable 2.6.34?

Will do.

thanks,

greg k-h
