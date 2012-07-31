Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2GaWvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:51:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:5422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab2GaWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:51:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129007867"
Date: Tue, 31 Jul 2012 15:51:05 -0700
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120731225105.GD14080@jonmason-lab>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-2-git-send-email-jon.mason@intel.com>
 <20120731222338.GA19134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731222338.GA19134@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:23:38PM -0700, Greg KH wrote:
> On Sun, Jul 29, 2012 at 05:26:33PM -0700, Jon Mason wrote:
> > + *   You should have received a copy of the GNU General Public License
> > + *   along with this program; if not, write to the Free Software
> > + *   Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> 
> You really are going to track the FSF's office movements for the next
> 40+ years?
> 
> > + *   The full GNU General Public License is included in this distribution
> > + *   in the file called LICENSE.GPL.
> 
> No it isn't, this sentance is totally wrong for any in-kernel code,
> please remove it.
> 
> Also do the same for all the other files you added please.

I echo'ed your original comments on this to Intel Legal and am waiting
on a response.  I 100% agree, but I need their signoff first.

It is worth noting that this version of the license is already in the
kernel in numerous other drivers:
drivers/sfi/*
drivers/scsi/isci/*
drivers/dma/ioat/dma_v3.c
drivers/net/wireless/iwlwifi/*
drivers/net/wireless/iwlegacy/*

Thanks,
Jon

> 
> greg k-h
