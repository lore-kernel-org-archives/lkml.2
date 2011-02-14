Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1BNQ52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:57:28 -0500
Received: from sous-sol.org ([216.99.217.87]:48330 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756119Ab1BNQ50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:57:26 -0500
Date: Mon, 14 Feb 2011 08:56:45 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        James Morris <jmorris@namei.org>
Subject: Re: Regression - Xorg start failed
Message-ID: <20110214165645.GJ9869@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
 <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
 <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
 <20110214003531.GH9869@sequoia.sous-sol.org>
 <20110214053826.GA2557@darkstar.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214053826.GA2557@darkstar.dhcp.inet.fi>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young (hidave.darkstar@gmail.com) wrote:
> On Sun, Feb 13, 2011 at 04:35:31PM -0800, Chris Wright wrote:
> > Commit 47970b1 ("pci: use security_capable() when checking capablities
> > during config space read") is just plain broken.  The normal capable()
> > interface returns true on success, but the LSM interface returns 0 on
> > success.
> 
> Chris, linus has reverted the original commit, so this does not apply.

Right, I'll send a new patch to James.

> Anyway I have tested this one, it works well. Feel free add my Tested-by line.

Thanks for confirming the fix Dave.

thanks,
-chris
