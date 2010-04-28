Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0D1TPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:15:12 -0400
Received: from kroah.org ([198.145.64.141]:56631 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab0D1TPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:15:09 -0400
Date: Wed, 28 Apr 2010 12:15:02 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, drjones@redhat.com,
       suresh.b.siddha@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       clalance@redhat.com, stable@kernel.org
Subject: Re: [stable] [PATCH] Fix NULL pointer for Xen guests
Message-ID: <20100428191502.GA29921@kroah.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
 <20100428112658.4cf11292.akpm@linux-foundation.org>
 <4BD87E72.4050609@redhat.com>
 <20100428115039.c276594a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428115039.c276594a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:50:39AM -0700, Andrew Morton wrote:
> I worry that if the -stable maintainer see me drop a patch, but the
> patch in Linus's tree doesn't have the stable tag, they might not merge
> the fix into -stable.  I bugged them about this scenario recently and
> the reply was a bit waffly ;)

It was?

I try my best, that if I see you drop a patch, to go dig through Linus's
tree to find if it landed there.  If not, I leave it in my queue, and do
that for a few releases.  If after a long time (like 6 months) I either
ping someone, or just drop it from my queue as I guessed that someone
dropped it for some reason.

If I miss one of these, please let me know.

> By far the safest thing to do is to include the stable tag in your
> changelog right at the outset.

Yes, that's the _easiest_ and will not get lost.

thanks,

greg k-h
