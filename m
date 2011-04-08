Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1DHXmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:42:18 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:42339 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1DHXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:42:16 -0400
Message-ID: <4D9F9D56.2050109@web.de>
Date: Sat, 09 Apr 2011 01:42:14 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <4D9F790B.2000300@web.de> <4D9F7A4B.3040606@gmail.com> <4D9F7BC0.8010003@web.de> <4D9F99AA.8060803@gmail.com>
In-Reply-To: <4D9F99AA.8060803@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC242A2DCA1FA240DBD7439CA"
X-Provags-ID: V01U2FsdGVkX19AyDtW3fZpkD1lI8DsqqsvpOgSbiyuURiIazVw
	8ZlRAHTs9hG6bg0mKkdB+sAhf4zTjt5vdkGUumvcbzneYBM52s
	lmByAB91c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC242A2DCA1FA240DBD7439CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-04-09 01:26, David Ahern wrote:
> On 04/08/11 15:18, Jan Kiszka wrote:
>> Let me check... indeed, I'm getting the same file-not-found here with
>> trace-cmd.git 9cce1c9b5b when starting it directly from its build dire=
ctory.
>>
>> But maybe your trace-cmd or kernel versions are too old / incompatible=
=2E
>> I'm not getting complaints about unparseable events with the above
>> snapshot and 2.6.38.
>=20
> 2.6.38.2 kernel, trace-cmd 3e8b5b8 which is March 18 (though git pull
> done this morning).
>=20
> For grins I checked-out 9cce1c9b5b and same error:
> trace-cmd record -e kvm -- sleep 1
> trace-cmd report 2>&1  | less
>=20
> You do have to put stderr onto stdout to see the messages I reported
> earlier. Or look for [FAILED TO PARSE] on the kvm_exit and
> kvm_emulate_insn lines.

I did that.

What I also did is updating trace-cmd git and then reinstalling the
latest plugins: make install_plugins prefix=3D$HOME. They then end up in
$HOME/.trace-cmd/plugins. Now I do not have a single error message
anymore, including that file not found.

Jan


--------------enigC242A2DCA1FA240DBD7439CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk2fnVYACgkQitSsb3rl5xQaeACfahnhOaA2BHiSO1JNV9SQ3EDx
NjMAoL4fRLt7FM8+ym8O6+FbZildfMjd
=aVXn
-----END PGP SIGNATURE-----

--------------enigC242A2DCA1FA240DBD7439CA--
