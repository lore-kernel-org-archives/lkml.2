Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0D0R7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:59:55 -0400
Received: from kroah.org ([198.145.64.141]:36665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab0D0R7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:59:49 -0400
Date: Tue, 27 Apr 2010 10:35:45 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Rooney <candyguitar@googlemail.com>
Cc: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com, svenne@krap.dk,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: Fixed 80-character line coding style
 issues in p80211req.c
Message-ID: <20100427173545.GA17535@kroah.com>
References: <92a765341003100046o179369d4r95dd99f08bdec6bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92a765341003100046o179369d4r95dd99f08bdec6bb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:46:30AM +0000, Patrick Rooney wrote:
> Sorry to add this as an attachment, but copying and pasting corrupts
> the patch, and git is telling me that: "git: 'send-email' is not a
> git-command. See 'git --help'." (was following the instructions in
> http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel; I
> use Ubuntu 9.10).

That is because you need to install the "git-email" package, or some
such thing...

thanks,

greg k-h
