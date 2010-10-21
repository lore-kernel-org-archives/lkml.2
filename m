Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab0JUSg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:36:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49732 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0JUSg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tdm3mjUR7tII+qWS+GHGp5rcqgaM70f3JZTFWoRSJYRWtw6MUJNEDZxD5MuiYmPdf2
         fYQVv64v4+3ar8yEMUrjCkuCYthBu7jls+/em8juf4kAqbIcPZMIFC5TaqBOQPYsCcTG
         topti8wSYp4VTAEbGtjZZ2/9mBA9pkFwpBx+g=
Date: Thu, 21 Oct 2010 14:36:21 -0400
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101021183621.GA2244@roll>
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette> <20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins> <1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins> <1287595605.3488.52.camel@twins> <20101021014843.GA21295@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20101021014843.GA21295@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2010 at 09:48:43PM -0400, tm@ wrote:
> On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
> >=20
> >=20
> > OK, how does this work for people? I find my idle load is still a tad
> > high, but maybe I'm not patient enough.
>=20
> I haven't had a chance to keep up with the topic, and I apologize. I'll be
> testing this as soon as I can finish compiling it. Thank you all for not
> letting this go unfixed.
>=20
> Tim McGrath

Now that I've actually had a chance to boot the kernel with the patch
applied I'm sorry to say but the load average isn't decaying as fast as it
ought to, at the very least. My machine's been idle for the last ten minutes
but the one minute average is still at 0.89 and shooting up to 1.5, the 5
min average is 0.9, and the 15 min average is .68 and climbing. Even as I'm
writing this the averages are continuing to drop, but *very* slowly.
Glacially, almost. The one minute average is continuing to randomly spike
high for no reason I can tell as well.

I'll let you guys know if this actually bottoms out at some point.

Tim McGrath

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTMCIJZEncCrqzVruAQIKbwf+J8bQZwttzGYPwGA6VES6K+CGyi1jJfHs
wL41J7ErZsapyLE5TotI12EwK98MgjTYh9HlQSpsCaMKHW/6LAbMiZY3BTP29H3t
bt4ZVn0qLN0oaQlOp03ElvMo5+M8mGKOMlMMv/qHFKmfZZqtcFI20mSg6cN1KeJn
cctzvCKbE0EEWmvVxkN/cCjWbE1ke5BzFeRlKk6MXA7wqwf8Y1PwXyyF2VzrdM4M
t27CreKqgP3lfdKezOLVN1B3upYLi2xDclw0gNxBy85NcS0o3Ilvdzj4y5Xry+i/
XlHrz+XlQI6j8R8P4OLK6FC9ul16wxV39h6gTkhSOyniQlPEPEBQzQ==
=Ad2W
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
