Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab2EWOVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:21:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50324 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2EWOVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:21:30 -0400
Date: Wed, 23 May 2012 17:25:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Staging: ipack/bridges/tpci200:
 tpci200_slot_unmap_space() should return 0 if succeed.
Message-ID: <20120523142503.GM4629@mwanda>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
 <1337781287-28628-4-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337781287-28628-4-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 03:54:42PM +0200, Samuel Iglesias Gonsalvez wrote:
> tpci200_slot_unmap_space() should return 0 if the operation was properly done. If
> not, the caller will think that something wrong happened.
> 

It's weird and frustrating that gcc didn't warn that we used "res"
without initializing it.  It feels like the goto out_unlock places
should return an error.  But actually the callers don't don't check
the return values so I guess it doesn't matter.

All these patches look good.

regards,
dan carpenter

