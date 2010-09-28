Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0I1Epx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 00:45:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55846 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0I1Epw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 00:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dotdko3+2lcbRIHfuU/H0HLGbsU63USzGDdCEqDraxfsk+14RJrbLEdMrNg9McVhZ0
         UDWgTPjLeJwfRYDfHla1mtYX/7wxdRcWufUoG1b5feSgG806UNWSDhiEfPoLBVfPZSsF
         Q5zIj23z4MH4NO+hdqYf2alZ5hTG/luw7MsYc=
Date: Tue, 28 Sep 2010 00:45:48 -0400
From: tmhikaru@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100928044548.GB12856@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab> <20100927233956.GA15705@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20100927233956.GA15705@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 27, 2010 at 07:39:56PM -0400, tmhikaru@gmail.com wrote:
> Greg, I noticed that in the ChangeLogs for 2.6.35.x there were some patches
> for the intel driver which seem to be to my untrained eye an attempt to fix
> Linus' problem talked about in that bug report; The patch that is referenced
> in the bug report contains some things at least that were not applied to the
> tree; since I have no idea what I'm looking at, could you verify for me if
> I'm barking up the right tree here? If I am, I'll try building a clean
> 2.6.35 kernel with that patch applied and see if my problem disappears.

WRT to this patch, it appears I was indeed barking up the wrong tree - it
doesn't apply to 2.6.35 at all. I guess I'll have to start bisecting now.
2.6.35.1 and 2.6.35 clearly have the problem. Just wanted to make it clear
that I'd been mistaken about this before you wasted time digging into it.

Thank you,
Tim McGrath

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKFy/JEncCrqzVruAQL4MQf9Epq0xbpcfFVmWCXLiBNcxVq93cB6rF/a
BsILn61SuW4AqWpa5AgZ/Qpxal9XbwKREbAaZ0D7J5zrlPmGQtoEHIY4HrAn8NUA
0rmnf70UA7T2LQTOrKcLPkbme/2h4sCdbBLy+Y47G8dc8UKk67bDOq7xe8a2StXe
UbildAMfkjIVT4fVW1tUVxUDcfLCdLOtqcXx8xfceI+rA7mhOX2sIrMExMfClxPc
jYoAiQTW5h0Efx02KL1B2LRj1JyFggxg0i23bxui9qaaaxOZnXuzVr4wzeznV6DU
26QbWjxRSAVhwAiexmzWHsF07ae7nTZlV6Ae2sky2vMT9L6SFuD9hg==
=PWfE
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
