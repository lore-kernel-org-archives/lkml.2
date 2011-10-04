Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1JDEtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 00:49:18 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38183 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1JDEtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:49:17 -0400
Date: Tue, 4 Oct 2011 00:49:14 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111004044914.GP6684@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>
References: <4E8655CD.90107@zytor.com>
 <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
 <20111003225651.GA10257@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003225651.GA10257@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:56:52PM -0700, Josh Triplett wrote:
> 
> Same question here.  I have a key, which has already accumulated some
> signatures, and I feel confident that key remains secure, along with the
> one and only system that key lives on.  I have a revocation certificate
> prepared for that key in a secure location, though I'd certainly welcome
> an escrow service from kernel.org as long as that service only stored
> encrypted documents to which only the key owner had the passphrase.  I
> don't see any need to generate an entirely new key in a hurry.
> Certainly transitioning to larger and algorithmically better keys over
> time seems like a good idea, but given the nature of the kernel.org
> compromise, immediate concerns about the strength of GPG keys seems much
> less warranted than concerns about the security of the systems they live
> on.

This is what I did.  I generated a new key a year ago, which has never
left my laptop.  I accumulated keys at linux.conf.au, and after I get
more signatures at the KS in Prague, my intention is to gradually
transition from the key generated in 1997, which has been used to sign
all of my Debian packages and e2fsprogs releases, to my new key.

But that's only because I'm reasonably confident I can trust my new
key, and I did a very careful examination of my laptop looking for
signs that my machines might have been penetrated --- before I
reinstalled it and my desktop at the same time, and initiated a full
password change cycle.  (Yes, that's paranoia.  With security, the
question is always, "are you paranoid *enough*"?)

Note that if your laptop allows incoming ssh connections, and you
logged into master.kernel.org with ssh forwarding enabled, your laptop
may not be safe.  So be very, very careful before you assume that your
laptop is safe.  At least one kernel developer, after he got past the
belief, "surely I could have never had my machine be compromised",
looked carefully and found rootkits on his machines.

       		     	   	       - Ted
