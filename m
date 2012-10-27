Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab2J0AXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 20:23:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57902 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2J0AXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 20:23:13 -0400
Date: Fri, 26 Oct 2012 20:22:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nix <nix@esperi.org.uk>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>, Peng Tao <bergwolf@gmail.com>,
        Trond.Myklebust@netapp.com, gregkh@linuxfoundation.org,
        linux-nfs@vger.kernel.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Message-ID: <20121027002258.GB31030@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org, linux-nfs@vger.kernel.org
References: <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508AF3FA.4020506@redhat.com>
 <87wqydx957.fsf@spindle.srvr.nix>
 <20121026205618.GC8614@thunk.org>
 <87objpx84k.fsf@spindle.srvr.nix>
 <20121026211542.GE8614@thunk.org>
 <87haphx76u.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87haphx76u.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:19:21PM +0100, Nix wrote:
> > prevent unwary civilians from coming across the feature and saying,
> > "oooh, shiny!" and turning it on.  :-(
> 
> Or having it turned on by default either, which seems to be the case
> now.

Huh?  It's not turned on by default.  If you mount with no mount
options, journal checksums are *not* turned on.

	 	 	       	     - Ted
