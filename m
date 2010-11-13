Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0KOBb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:31:28 -0500
Received: from thunk.org ([69.25.196.29]:44657 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0KOBbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:31:21 -0500
Date: Sat, 13 Nov 2010 18:33:53 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Message-ID: <20101113233353.GB18658@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Thomas Meyer <thomas@m3y3r.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <201011032334.30662.thomas@m3y3r.de>
 <201011080014.33354.thomas@m3y3r.de>
 <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
 <1289242528.11571.8.camel@localhost.localdomain>
 <alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
 <1289418184.6530.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289418184.6530.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:43:04PM +0100, Thomas Meyer wrote:
> > 
> > I leave it to the ext4 experts to solve it for real :)
> > 
> 
> I just booted into 2.6.37-rc1-00166-g814ce25 and I don't see above bug
> in this kernel. So it seems as this bug got fixed in between 2.6.36 and
> 2.6.37-rc1+

Yes, this was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
NULL pointer dereference in print_daily_error_info()).  I'll put it on
my list of things to be backported to 2.6.36.

					- Ted
