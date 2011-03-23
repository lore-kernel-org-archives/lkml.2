Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab1CWXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:16:21 -0400
Received: from kroah.org ([198.145.64.141]:60490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab1CWXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:16:20 -0400
Date: Wed, 23 Mar 2011 15:50:01 -0700
From: Greg KH <greg@kroah.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stable@kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        linux-pci@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [stable] [PATCH stable] PCI: return correct value when writing
 to the "reset" attribute
Message-ID: <20110323225001.GD27334@kroah.com>
References: <20110323122103.GA24976@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323122103.GA24976@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:21:03PM +0200, Michael S. Tsirkin wrote:
> commit 447c5dd7338638f526e9bcf7dcf69b4da5835c7d
> Author: Michal Schmidt <mschmidt@redhat.com>
> Date:   Tue May 11 11:44:54 2010 +0200
> 
> A successful write() to the "reset" sysfs attribute should return the
> number of bytes written, not 0. Otherwise userspace (bash) retries the
> write over and over again.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Applies without changes to all of 2.6.32,2.6.33,2.6.34

Applied to .32 and .33 now, thanks.

greg k-h
