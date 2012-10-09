Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JIAmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:42:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48901 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2JIAmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:42:13 -0400
Date: Mon, 8 Oct 2012 17:42:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: xiong@qca.qualcomm.com, mcgrof@kernel.org, backports@vger.kernel.org,
        nic-devel@qualcomm.com, Ren Cloud <cjren@qca.qualcomm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        qca_vkondrat@qca.qualcomm.com
Subject: Re: [PATCH] compat-drivers: update ethernet driver alx in crap dir
Message-ID: <20121009004209.GC9068@kroah.com>
References: <1349400892-25315-1-git-send-email-xiong@qca.qualcomm.com>
 <CAB=NE6VotAu-cugsn4==3TPX0OGPEFtdn1J+5+Rd_YfLcg9YDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6VotAu-cugsn4==3TPX0OGPEFtdn1J+5+Rd_YfLcg9YDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:25:08PM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 4, 2012 at 6:34 PM,  <xiong@qca.qualcomm.com> wrote:
> > From: xiong <xiong@qca.qualcomm.com>
> >
> > 1. support new device id (0x10A0/0x10A1).
> > 2. add DEBUG_FS interface for diag/swoi functions.
> >
> > Signed-off-by: Ren Cloud <cjren@qca.qualcomm.com>
> > Signed-off-by: xiong <xiong@qca.qualcomm.com>
> 
> Xiong,
> 
>  -- Vladimir, just a heads up -- this applies to you as well for the
> 802.11ad wil6210 driver
>  -- Greg, some review on your preference on this would be appreciated

Preference on what?  I've never seen this driver before, why wasn't it
submitted to be in the staging tree in the first place?

> The original alx crap patch was added into compat-wireless on the
> linux-3.5.y branch.

What is "crap patch"?  And is this the old driver with the dubios
history keeping it from ever being merged anywhere, or is this something
new?

> Its been two kernel releases and alx is not yet
> upstream and users can only get alx via compat-drivers (technically
> compat-wireless as that was pre v3.7). v3.7 would be the *third*
> release in which this would happen... This is unfair to users and
> consumers of the Linux kernel and derails expectations and our
> arrangements for Linux kernel development. I realize that the goal was
> to get alx upstream ASAP but regardless of what the reason is, its not
> yet upstream. If you cannot work on alx on a timely manner to get
> upstream then please submit the driver to the staging area of the
> Linux kernel that Greg maintains so that other developers who may be
> able to help can submit patches to help you. Under staging your driver
> should be accepted so long as it compiles.
> 
> I will update the documentation for crap/ patches for compat-drivers
> to make it clear now that crap/ patches can be used for adding
> components / pieces of code not yet ready for upstream but as far as
> full new drivers are concerned you only get one kernel release cycle
> for it to linger on crap/ under compat-drivers, if you haven't
> addressed upstreaming yet then it should go to drivers/staging/. That
> is crap/ should only be used as a shortcut because users exist that
> can use the driver but you *do* have a team properly resourced to
> address upstreaming properly in a timely manner.

Why do you even need crap/ at all?  What is keeping drivers like this
(if it isn't the legally dubious driver) from being merged into staging
today?  And if it is the legally dubious driver, well, you had better
not be taking it in your tree either...

confused,

greg k-h
