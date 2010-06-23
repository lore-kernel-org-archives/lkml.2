Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0FWW1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:27:38 -0400
Received: from kroah.org ([198.145.64.141]:37744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0FWW1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:27:35 -0400
Date: Wed, 23 Jun 2010 15:17:49 -0700
From: Greg KH <greg@kroah.com>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, ossama.othman@intel.com, randy.dunlap@oracle.com,
       alan@linux.intel.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Message-ID: <20100623221749.GA8336@kroah.com>
References: <1276519227-4987-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276519227-4987-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 03:40:27PM +0300, Henri Häkkinen wrote:
> Forward declared memrar_allocator in memrar_allocator.h and moved it
> to memrar_allocator.c file.  Implemented memrar_allocator_capacity(),
> memrar_allocator_largest_free_area(), memrar_allocoator_lock() and
> memrar_allocator_unlock().

Shouldn't this be more than just one single patch?

Please only do one thing per patch.

Care to respin these and take into consideration the other comments for
this patch?

thanks,

greg k-h
