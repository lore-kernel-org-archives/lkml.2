Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2A0TiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:38:08 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35195 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab2A0TiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:38:06 -0500
X-Sasl-enc: xmm7sFeRhvwo5+H4kQ6INimrSooYq6JjoEPOTL5X55Vc 1327693082
Date: Fri, 27 Jan 2012 17:37:56 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Re: Ioctl warning for a partition
Message-ID: <20120127193756.GC25348@khazad-dum.debian.net>
References: <20120126223037.GE28368@quack.suse.cz>
 <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
 <4F21E828.8090502@msgid.tls.msk.ru>
 <20120127192817.GB25348@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127192817.GB25348@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Jan 2012, Michael Tokarev wrote:
> > mdadm ioctls reported in various places apparently got fixed by
> > ENOTTY/ENOIOCTLCMD change.
> 
> Does that fix still need to be backported to -stable?
> 
> Linux v3.0.18 + Debian stable userspace (mdadm v3.1.4) causes this on
> boot (when mdadm runs in the initramfs):
> 
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!

This is on x86-64/amd64.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
