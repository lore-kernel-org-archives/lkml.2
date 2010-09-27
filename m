Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab0I0TJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:09:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56673 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab0I0TJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P/V4WFDcuEoi7njKZ7yWSWklAWKXAFmw6Faf6rQWSmkos5OdUeCzHKv0kQpKz7fDJK
         CKUyDJqUovc1Z7zS1SasvrlNgln/c2Fb2iyrg+sq0lco3wCThs9gOsQN41UQKozBKOdg
         dK3h4zuXO3zk/s7BEriD10BjrPXx7VHhivwBI=
Date: Mon, 27 Sep 2010 15:09:30 -0400
From: tmhikaru@gmail.com
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927190930.GA7086@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927175412.GA23347@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20100927175412.GA23347@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 10:54:12AM -0700, Greg KH wrote:
> On Mon, Sep 27, 2010 at 12:32:08PM -0400, tmhikaru@gmail.com wrote:
> > 	I'm not exactly sure what's going on here and I'd like some help
> > figuring out what is. For some inexplicable reason, ever since I started
> > using the 2.6.35.x series with the 2.6.35.3 release, my loadaverages te=
nd to
> > bounce anywhere from as low to .2 to 1.5 - constantly, while the machine
> > seems idle.
>=20
> But .34 doesn't show this issue?
>=20
> If so, can you run 'git bisect' between the .34 and .35 releases to find
> out where the problem comes in?

=2E34 does not, that is correct.
>=20
> > Consistently, there are no programs in D state in ps aux output,
> > no cpu hogging programs running in top, nothing I can see that should
> > explain the bizzarely high load average.
>=20
> Loadaverage can be affected by a driver doing an uninteruptable sleep.
> This doesn't actually cause a load on the system, but it does affect the
> way that number is calcuated.  Perhaps that's the problem here.
>

That would explain a lot.
> > 	If you have any tips or recommendations on what I should use to
> > investigate this further, please let me know. Once I have ensured to my=
 own
> > satisfaction that I'm not doing something bizzare that's screwing up my
> > machine, I'll make a detailed bug report and start on figuring out how =
to
> > use git bisect.
>=20
> 'man git-bisect' will help with this :)
>=20
> thanks,
>=20
> greg k-h

Thank you for the tips. If I don't find anything obvious I'll bisect it very
soon, but I'll likely attempt to track backwards from .3 myself since I've
backtracked through patches before. Once I have narrowed it down to a patch
release it'll likely take less time to bisect. (eg, if I know it happened
between 2.6.35-rc1 and rc2 I'd only have to bisect the patches between those
versions, whereas right now I only know positively between 2.6.34 and
2.6.35.3 something went wrong.)

Tim McGrath

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKDr6pEncCrqzVruAQJLSgf+P4KzAKCCVEpDhxYz2PCWo//buyP/+gRP
APMqLFWHiiyTi+LHWi1pl64AqgHoqUD2Vr0ljz8Cuz28mT5D7bIXZOGBMISr5gUe
ReyQxR8zd51ufQF2pm0Hu9r9jyuTM+9iW9tsfQ/o5BpviaZTOERi/17ScuS3GK2h
O+/wooLvdpTJHtfHt4WFiK1ZXbt6bCTG8PSRrQuKCPNt9liGrz+lXDW+wt+N9p3t
HRPmt6ISDFLG0ZTwzkaUvpKLHpdlF3AA6InHKe5pc8VvLqtFbUi4YdxpmnLXs9mi
F297U4UiSKNA61OfxH6kvJLGSJqPjqhkzeN1LF8oYznxpVMElZhP3Q==
=0BTF
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
