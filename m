Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2BHIqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 03:46:07 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:53542 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab2BHIqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 03:46:06 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnuYANY1Mk9V5qrvPGdsb2JhbABEiVSlEXsZAQEBATc0gXIBAQU6HBMBDxAIAw4KLhQlChoTh3+5LhOLBDcCAgkFDAcGAQQBAQkEFAcEDwMDAYJ1AgsDBBoEAoEJAgoCBIJXYwSVK4VojHc
X-IronPort-AV: E=Sophos;i="4.73,383,1325458800"; 
   d="scan'208";a="265295020"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 8 Feb 2012 09:47:38 +0100
To: Matthew Garrett <mjg@redhat.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] hfsplus: Add an ioctl to bless files
Message-ID: <20120208084738.GA2143@polaris.bitmath.org>
References: <20120206174943.GA14225@infradead.org>
 <1328559280-29111-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328559280-29111-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 03:14:40PM -0500, Matthew Garrett wrote:
> Making an hfsplus partition bootable requires the ability to "bless" a
> file by putting its inode number in the volume header. Doing this from
> userspace on a mounted filesystem is impractical since the kernel will
> write back the original values on unmount. Add an ioctl to allow userspace
> to update the volume header information based on the target file.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---

Works nicely, great stuff.

    Tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
