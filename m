Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1EFQ1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:27:17 -0400
Received: from kroah.org ([198.145.64.141]:40468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1EFQ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:27:16 -0400
Date: Fri, 6 May 2011 09:17:54 -0700
From: Greg KH <greg@kroah.com>
To: Jim Schutt <jaschut@sandia.gov>, James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 04/38] [SCSI] put stricter guards on queue dead
 checks
Message-ID: <20110506161754.GA31472@kroah.com>
References: <20110506001207.658271797@clark.kroah.org>
 <4DC40B94.9060903@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC40B94.9060903@sandia.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 08:54:12AM -0600, Jim Schutt wrote:
> Hi Greg,
> 
> Greg KH wrote:
> >2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 
> You probably don't want to add this patch to stable kernels
> until commit c055f5b2614b4f from
>   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
> shows up in Linus' tree.
> 
> See details in http://www.spinics.net/lists/kernel/msg1181665.html.

James, do you agree with this?

thanks,

greg k-h
