Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1JDFLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 01:11:52 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50549 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1JDFLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 01:11:51 -0400
Date: Tue, 4 Oct 2011 01:11:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111004051141.GR6684@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>
References: <4E8655CD.90107@zytor.com>
 <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
 <20111003225651.GA10257@leaf>
 <20111004044914.GP6684@thunk.org>
 <4E8A910D.6020107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8A910D.6020107@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:52:29PM -0700, H. Peter Anvin wrote:
> On 10/03/2011 09:49 PM, Ted Ts'o wrote:
> > 
> > Note that if your laptop allows incoming ssh connections, and you
> > logged into master.kernel.org with ssh forwarding enabled, your laptop
> > may not be safe.  So be very, very careful before you assume that your
> > laptop is safe.  At least one kernel developer, after he got past the
> > belief, "surely I could have never had my machine be compromised",
> > looked carefully and found rootkits on his machines.
> > 
> By the way, I'm now pretty convinced that allowing inbound ssh on
> laptops (which is the default on all the mainline Linux distros as far
> as I know) is seriously broken... laptops get connected to *extremely*
> insecure networks on just way too regular a basis.

+1000

I'll note though that at least some Linux distributions when
customized by corporate security types tend to disable incoming ssh.
If your company doesn't, it probably should... 

... and it should definitely raise a firewall and disable NAT and
incoming ssh if you're connected to the corporate VPN.  I once heard a
story several years back when someone I knew was staying at a hotel in
Beaverton, and connected to an open WiFi access point to get internet
access.  Very shortly there afterwards, he realized he was connected
behind the Intel corporate firewall, at which point he (not being an
Intel employee, and conscious of the Business Conduct Guidelines that
he was require to sign every year) disconnected as quickly as
possible.

Oops.  :-)

						- Ted
