Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0CRSYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:24:09 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:54518 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0CRSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject:in-reply-to:mime-version
         :x-firegpg-version:content-type;
        b=uIoFj5VcJJ8eOhmkQptsDuZQcDfri7EX4Gj89DzgH+wMTswy6w2Pvm+ir+M6uYZA7L
         dCMWa4L0a1PjGK7iuDswZOYMYAc+5gmq8wjtVZq9Eb68MXSeOCXo7epUKaUe5aglaeX4
         1UZId6WiebWekccmtyxn7Kqz0oG9kQO4a9/jw=
From: drepper@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Date: Thu, 18 Mar 2010 11:23:53 -0700 (PST)
Message-ID: <g6xw3whylji5t7k79aUYAxe124vaj_firegpg@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
In-Reply-To: <20100318161310.GA447@elte.hu>
MIME-Version: 1.0
X-FireGPG-Version: 0.7.10
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="-----firegpg0710eqg6xw3wjln7fx8msvfd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
-------firegpg0710eqg6xw3wjln7fx8msvfd
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMTgsIDIwMTAgYXQgMDk6MTMsIEluZ28gTW9sbmFyIDxtaW5nb0BlbHRlLmh1
PiB3cm90ZToNCj4gVGhlIHN1Y2thZ2Ugb2Yga2VybmVsIGFzeW5jIElPIGlzIGZvciBzaW1pbGFy
IHJlYXNvbnM6IHRoZXJlJ3MgYW4gdWdseSBwYWNrYWdlDQo+IHNlcGFyYXRpb24gcHJvYmxlbSBi
ZXR3ZWVuIHRoZSBrZXJuZWwgYW5kIGJldHdlZW4gZ2xpYmMNCg0KQm9sbG9ja3MuICBnbGliYyB3
b3VsZCB1c2UgKGFuZCBpcyB1c2luZykgZXZlcnl0aGluZyB0aGUga2VybmVsIHByb3ZpZGVzLiAg
V2UgZXZlbiBoYXZlIGFuIGltcGxlbWVudGF0aW9uIHVzaW5nIHRoZSBjdXJyZW50IEFJTyBjb2Rl
LiAgSXQgb25seSB3b3JrcyBpbiBzb21lIHNpdHVhdGlvbnMgYnV0IHRoYXQncyB3aGF0IHRoZSBm
ZXcgdXNlcnMgYXJlIE9LIHdpdGguDQoNCkRvbid0IHRyeSB0byBibGFtZSBhbnlvbmUgYnV0IGtl
cm5lbCBwZW9wbGUgZm9yIHRoZSBjb21wbGV0ZSBhbmQgdXR0ZXIgZmFpbHVyZSBvZiBBSU8gaW4g
TGludXguICBJIGRvbid0IGtub3cgaG93IG9mdGVuIEkndmUgZGlzY3Vzc2VkIGRlc2lnbiBvZiBh
IGtlcm5lbCBpbnRlcmZhY2Ugd2l0aCB2YXJpb3VzIGtlcm5lbCBkZXZlbG9wZXJzLiAgSGVjaywg
d2hlbmV2ZXIgWmFjaCBCcm93biBhbmQgSSBtZWV0IHRoZXJlIG5ldmVyIGlzIGEgZGlmZmVyZW50
IHRvcGljLiAgQW5kIGZvbGxvd2luZyB0aGVzZSBtZWV0aW5ncyB0aGUgYmFsbCBpcyBub3QgYW5k
IGNhbm5vdCBiZSBpbiBteSBjb3VydC4gIEhvdyBjb3VsZCBpdD8NCg==
-------firegpg0710eqg6xw3wjln7fx8msvfd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Use GnuPG with Firefox : http://getfiregpg.org (Version: 0.7.10)

iEYEARECAAYFAkuib7wACgkQ2ijCOnn/RHTKvQCglviqBI2fkXbkoN35aIEh5lRi
hacAnAtrS28sXJ6xir8X1XHvdSijjSTE
=UUuC
-----END PGP SIGNATURE-----

-------firegpg0710eqg6xw3wjln7fx8msvfd--

