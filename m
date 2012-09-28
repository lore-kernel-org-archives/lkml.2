Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2I1Rfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:35:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51225 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2I1Rfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:35:43 -0400
Date: Fri, 28 Sep 2012 10:35:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Input and HID updates for 3.7
Message-ID: <20120928173539.GB6356@core.coreip.homeip.net>
References: <20120919185605.GA778@polaris.bitmath.org>
 <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:52:01PM +0200, Jiri Kosina wrote:
> On Wed, 19 Sep 2012, Henrik Rydberg wrote:
> 
> > Hi Jiri,
> > 
> > Please pull this tree to receive Input and HID updates for 3.7. The
> > tree contains input core changes, Acked by Dmitry, which substantially
> > reduces the irqsoff latency for all input devices. It also contains MT
> > changes which allows further memory reduction, speedup and hardware
> > support in the HID Multitouch driver. Lastly, you get the conversion
> > of the bcm5974 driver to MT-B, which due to the mixed dependency of
> > the tree fits better here than anywhere else.
> > 
> > Thanks,
> > Henrik
> > 
> > The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:
> > 
> >   Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://github.com/rydberg/linux.git for-next
> 
> Pulled. Thanks Henrik, thanks Dmitry.

Hmm, it looks like the work on making evdev using dynamic device numbers
will clash with Henrik's changes. I think I will also pull this into my
tree and then git should be able to resolve it all properly in -next.

Thanks.

-- 
Dmitry
