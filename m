Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2JAWRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:17:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2JAWRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:17:08 -0400
Date: Tue, 2 Oct 2012 00:16:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Input and HID updates for 3.7
In-Reply-To: <20120929090217.GA1290@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1210020016150.23544@pobox.suse.cz>
References: <20120919185605.GA778@polaris.bitmath.org> <alpine.LNX.2.00.1209192351120.22959@pobox.suse.cz> <20120928173539.GB6356@core.coreip.homeip.net> <alpine.LNX.2.00.1209282218350.17437@pobox.suse.cz> <20120929090217.GA1290@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2012, Henrik Rydberg wrote:

> > > Hmm, it looks like the work on making evdev using dynamic device numbers
> > > will clash with Henrik's changes. I think I will also pull this into my
> > > tree and then git should be able to resolve it all properly in -next.
> > 
> > That should work. Alternatively you can pull 'from-henrik' branch from my 
> > tree in case Henrik has already ditched/rebased his tree.
> 
> The tree will remain the same until after 3.7-rc1 is out, so pulling
> should be fine.

Linus has just pulled from hid.git, so you can cross-check the pending 
changes now.

Thanks,

-- 
Jiri Kosina
SUSE Labs
