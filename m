Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934564Ab2DLSE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:04:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53827 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932923Ab2DLSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:04:23 -0400
Date: Thu, 12 Apr 2012 19:04:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120412180416.GC18049@opensource.wolfsonmicro.com>
References: <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <20120411112411.11825eec@pyramind.ukuu.org.uk>
 <20120411103827.GH3163@opensource.wolfsonmicro.com>
 <4F856173.8000901@cam.ac.uk>
 <20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
 <4F8568A8.5060206@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <4F8568A8.5060206@cam.ac.uk>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 12:19:04PM +0100, Jonathan Cameron wrote:
> On 4/11/2012 12:13 PM, Alan Cox wrote:

> >Your simple IIO examples would just use the ADC abstraction, your complex
> >IIO examples would use the ADC abstraction *and* layer it with IIO level
> >code that is mixing it with all the other needed work.

> I suspect you'll end up adding more and more to your adc abstraction
> till you actually
> end up with most of IIO.  That's effectively what we did...   It's
> big because there are
> actually not that many 'simple' adc's out there.

I tend to agree here - I think if we try to establish a strict
separation between the simple and complex abstractions it'd cause more
problems than it will solve trying to split things, and from a hardware
driver level it helps if there's just one upper layer.

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhxkKAAoJEBus8iNuMP3d8ksP/30bth1eMkE4yeIIkplZ/Si6
SA4p+nU/8i7ppY6J9BY9gxnF1q4VL2+T868Wiz6YSbAUsVwkxDDhLiJzPc9f6Jh3
fg49b5PvCRLU8+D15fJcnDF4w7LmD30JgqJ2MxoLye+w6EqmAlP3XgWuMpdLXOo2
M4ztsjmw1eU3XHGuoC5mz+TBx5wjZSKbbc4yzynCjQ/DwzVLb/j45UbNkOSY8wKR
fMsVfiRDCj+Ws5DeJ8jj7BOmIiQlHogIjiigfZGfMuliSBo7oBcJSlRiTOm6VC4D
Qj5JdaJ4oC9uKGusfri1dk0599JEb9alfh0hp7NKyFXph8ybZSBouP1VdXsI58lh
RS0PtE4N6JBeyQHR1TnN+NUhEQdpXTe6FHb9ZQ1qdYHiqeXdQNaB/krZu+5hILTn
xhQmBK1wg2F8ywIg9y7X00r0a5EdMcTM7JhF6jIPDIEyBaLl0c5wlUpFidgNUZrJ
4Q/srLt6HDtY4Cfq8kBXBvuAiNuApgkj4zZMYL0DzQ7E61hkxC3TAqBvPD3q6Xc3
cNvzQXZ4jUQiMazpA7ye/HuzXvyIO3Vi1jZzAv189li+CPCjJmJHIkY/Kf9iJWur
iMdgDHWsG9MfnmmlTuDLdtGF5+HT8autYcMa1leNh87UczhSOAyz/pl+NfX2uJ4f
zI2PAWVl7XId2DB4O66T
=PnYl
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
