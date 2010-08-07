Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0HGFPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 01:15:46 -0400
Received: from kroah.org ([198.145.64.141]:59408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0HGFPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 01:15:44 -0400
Date: Fri, 6 Aug 2010 22:15:09 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to
 userspace after freezing the fs with a mutex held
Message-ID: <20100807051509.GA25191@kroah.com>
References: <20100730171510.105264205@clark.site>
 <4C56B45E.9010601@canonical.com>
 <4C56FA35.7060607@redhat.com>
 <20100802184806.GA16878@kroah.com>
 <20100807040732.GB16342@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807040732.GB16342@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 01:07:32AM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 02 Aug 2010, Greg KH wrote:
> > On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
> > > On 08/02/2010 07:04 AM, Stefan Bader wrote:
> > > > We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
> > > > mentioned which is supposed to fix things but its not upstream, yet.
> > > > Do you know what happened to that?
> > > 
> > > right, patch below is needed to fix things.
> > > 
> > > Ted just acked it on the list recently; Greg, I'd either drop 116/165
> > > for now, or include the patch below which should be upstream soon...
> > 
> > I can't take anything that isn't upstream yet.
> > 
> > And I just released with this patch in the kernel, should I do a revert
> > and do a new release?
> 
> Any answers on this?

Nope :(
