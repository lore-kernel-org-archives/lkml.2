Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1GEThK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:37:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58121 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1GEThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:37:07 -0400
Date: Tue, 5 Jul 2011 15:37:04 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 7/9] KVM-GST: KVM Steal time accounting
Message-ID: <20110705193704.GG3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-8-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-8-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> This patch accounts steal time time in account_process_tick.
> If one or more tick is considered stolen in the current
> accounting cycle, user/system accounting is skipped. Idle is fine,
> since the hypervisor does not report steal time if the guest
> is halted.
>=20
> Accounting steal time from the core scheduler give us the
> advantage of direct acess to the runqueue data. In a later
> opportunity, it can be used to tweak cpu power and make
> the scheduler aware of the time it lost.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2fgAAoJEH65iIruGRnNKpgH/2ByIkD5uhDD0QwxXrffsN4M
KKt/PqMRylOh8bBWObL/XDfDDP6upey8O67voFJSFlLPQMNlO1SUsAW6c4Wk5FKp
9bhXAskqHIY0I4OBzpZqoyYss+/QVux5T1dNWT6cWD27REITqJoy6qJT1w8zVQ1Q
aX+4fJcqXXEzYk5MYIxVsH1GTA7dz0fE5nF8CmfOi6hpbNb+LVl6JTsq+qdk8lQx
2eA9dCXKjzR8nRAkMmLqVECLRxJMcUrr/0D1VULDYGAR01rOMtyI2nJFDR0UAVPh
eF/15XPv4isE0A9M07NXfD2nJn+RRbeTKxnBnqO1Z39nLdf5vr9H3SJiAkyIHKE=
=iUdl
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
