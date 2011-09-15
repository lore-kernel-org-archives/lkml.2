Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab1IORkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:40:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab1IORj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:39:59 -0400
Date: Thu, 15 Sep 2011 12:39:50 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Leopold Palomo-Avellaneda <leo@alaxarxa.net>, linux-kernel@vger.kernel.org,
        Adam Baker <linux@baker-net.org.uk>, linux-parport@lists.infradead.org,
        630593@bugs.debian.org, Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
Message-ID: <20110915173950.GA19450@elie>
References: <201109151441.15015.leo@alaxarxa.net>
 <20110915133555.GB16636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915133555.GB16636@kroah.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH wrote:

> You can not add someone else's signed-off-by: line to a patch, please go
> re-read Documentation/SubmittingPatches as to why.
>
> And did Adam originally write this patch?  Or did you?  If Adam, please
> set the authorship information properly.

>From a quick Google search:

http://lists.infradead.org/pipermail/linux-parport/2008-March/000628.html

It looks like this one does have Adam Baker's sign-off (and it is sad
how long this patch seems to have sat without being submitted to
mainline).

I don't know who originally had the idea of removing that code.  See
[1], [2], [3], and [4] for some early discussions.

The current "intel parport bug" test this patch removes seems to have
been introduced between 2.3.10pre5 and 2.3.10 (thanks to Dave Jones
for the git tree that makes such searches easy!).  That means some
time around June or July, 1999.  At the time, the parport maintainers
according to MAINTAINERS were Phil Blundell, Tim Waugh, David
Campbell, and Andrea Arcangeli.  From the patch "[PATCH] parport is an
orphan", 2007-03-05, I infer that not all of them are still interested
in the driver and whoever _is_ interested is probably subscribed to
the (low-volume) linux-parport list.

I'd say, why not get this patch in linux-next or -mm somehow and see
if anyone screams?  It would be _very_ useful to find an actual
instance of the "intel parport bug" so we could see what that code was
supposed to do and do it better.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.parport/322/focus=326
[2] http://thread.gmane.org/gmane.linux.parport/324/focus=327
[3] http://thread.gmane.org/gmane.linux.parport/806
[4] http://thread.gmane.org/gmane.linux.parport/925/focus=929
