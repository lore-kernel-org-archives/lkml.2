Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0HGEHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:07:39 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59877 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab0HGEHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:07:37 -0400
X-Sasl-enc: XkzC9kd3EpGCC5yXQSNPdCOl8VjdlXeH2h5u8cjbmEc4 1281154054
Date: Sat, 7 Aug 2010 01:07:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to
 userspace after freezing the fs with a mutex held
Message-ID: <20100807040732.GB16342@khazad-dum.debian.net>
References: <20100730171510.105264205@clark.site>
 <4C56B45E.9010601@canonical.com>
 <4C56FA35.7060607@redhat.com>
 <20100802184806.GA16878@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802184806.GA16878@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010, Greg KH wrote:
> On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
> > On 08/02/2010 07:04 AM, Stefan Bader wrote:
> > > We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
> > > mentioned which is supposed to fix things but its not upstream, yet.
> > > Do you know what happened to that?
> > 
> > right, patch below is needed to fix things.
> > 
> > Ted just acked it on the list recently; Greg, I'd either drop 116/165
> > for now, or include the patch below which should be upstream soon...
> 
> I can't take anything that isn't upstream yet.
> 
> And I just released with this patch in the kernel, should I do a revert
> and do a new release?

Any answers on this?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
