Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1LUVMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:12:20 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:56621 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1LUVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:12:18 -0500
Date: Wed, 21 Dec 2011 16:12:13 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
        ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
Message-ID: <20111221211213.GB32561@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
 <1323800557.3355.31.camel@jlt3.sipsolutions.net>
 <20111213201752.GA5094@thunk.org>
 <20111214015959.GA6276@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214015959.GA6276@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 08:59:59PM -0500, Ted Ts'o wrote:
> On Tue, Dec 13, 2011 at 03:17:52PM -0500, Ted Ts'o wrote:
> > Well, this patch seems to fix things for the non-authenticated case.
> > I can now associate with the GoogleGuest SSID without any problems.
> > I'm still having problems associating with the EAP-TLS encrypted
> > network, but that looks like it's a different bug.  (And that may
> > explain why I had so much trouble bisecting this; there are two issues
> > that have very similar symptoms.)
> 
> ... and the second problem I had with associating with EAP-TLS
> encrypted SSID's was solved by Wey-Yi's patch: 
> 
> 	  iwlwifi: allow to switch to HT40 if not associated yet
> 
> ... found in the thread "iwlagn regression in v3.1.5"
> 
> So with these two patches applied, things are now stable for me.

It seems that fixes for these two issues haven't been pushed to Linus
yet?  It would be nice if they could get pushed to mainline before 3.2
ships, as opposed to being something that has to get fixed in the
3.2.X series....

						- Ted
