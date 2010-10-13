Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0JMNmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:42:44 -0400
Received: from kroah.org ([198.145.64.141]:53284 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0JMNmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:42:42 -0400
Date: Wed, 13 Oct 2010 06:36:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the usb tree with the
	scsi tree
Message-ID: <20101013133607.GA8975@kroah.com>
References: <20101013142558.c46a6311.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013142558.c46a6311.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 02:25:58PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/sd.c: In function 'read_capacity_10':
> drivers/scsi/sd.c:1637: error: 'struct scsi_disk' has no member named 'hw_sector_size'
> 
> Caused by commit a488ec87ee2e79911d10425cb0c0264290905b38 ("scsi/sd: add
> a no_read_capacity_16 scsi_device flag") interacting with commit
> 526f7c7950bbf1271e59177d70d74438c2ef96de ("[SCSI] sd: Fix overflow with
> big physical blocks") from the scsi tree.
> 
> I have applied the following patch for today and will carry it as a merge
> fix as necessary.

Thanks for carrying the fix, I'll make sure to keep it in mind if I end
up merging after James does with Linus.

thanks,

greg k-h
