Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2K3UbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:31:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2K3UbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:31:15 -0500
Date: Fri, 30 Nov 2012 18:18:59 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2] kvm: Fix user memslot overlap check
Message-ID: <20121130201858.GB19821@amt.cnet>
References: <20121129210725.9364.72668.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129210725.9364.72668.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:07:59PM -0700, Alex Williamson wrote:
> Prior to memory slot sorting this loop compared all of the user memory
> slots for overlap with new entries.  With memory slot sorting, we're
> just checking some number of entries in the array that may or may not
> be user slots.  Instead, walk all the slots with kvm_for_each_memslot,
> which has the added benefit of terminating early when we hit the first
> empty slot, and skip comparison to private slots.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thanks.

