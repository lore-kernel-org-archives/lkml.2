Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0HBSsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:48:17 -0400
Received: from kroah.org ([198.145.64.141]:43642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab0HBSsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:48:16 -0400
Date: Mon, 2 Aug 2010 11:48:06 -0700
From: Greg KH <greg@kroah.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to
 userspace after freezing the fs with a mutex held
Message-ID: <20100802184806.GA16878@kroah.com>
References: <20100730171510.105264205@clark.site>
 <4C56B45E.9010601@canonical.com>
 <4C56FA35.7060607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C56FA35.7060607@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
> On 08/02/2010 07:04 AM, Stefan Bader wrote:
> > We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
> > mentioned which is supposed to fix things but its not upstream, yet.
> > Do you know what happened to that?
> 
> right, patch below is needed to fix things.
> 
> Ted just acked it on the list recently; Greg, I'd either drop 116/165
> for now, or include the patch below which should be upstream soon...

I can't take anything that isn't upstream yet.

And I just released with this patch in the kernel, should I do a revert
and do a new release?

thanks,

greg k-h
