Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2HIRJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:09:40 -0400
Received: from exout101.netflix.com ([69.53.237.162]:22773 "EHLO
	exout103.netflix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754670Ab2HIRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:09:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024;d=netflix.com;
  h=from:to:cc:subject:date:message-id:references:in-reply-to
    :content-type:mime-version;
  b=MC0HVne1a+AXYMUU8Fr7g7SjceZL45Ay39DO55kVxWpfPDxoIBx7ilgrAN88nOHKR2TeK8Nk
    2y3Wvs8azGU+k9KxXNKMV+93m4IRXgfZbtSmW38zyn4d1ptFJpzQVW+DJrN3Q+ApF0zYwW/4
    yzpg/Cg3dg6nFy+71IOqY12myU0=
From: Wesley Miaw <wmiaw@netflix.com>
To: Milan Broz <mbroz@redhat.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?Windows-1252?Q?Will_Drewry=99?= <w@google.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dm: verity support data device offset
 (Linux 3.4.7)
Thread-Topic: [dm-devel] [PATCH v2 2/2] dm: verity support data device
 offset (Linux 3.4.7)
Thread-Index: AQHNdceQq1EArTHW80uk0EvYgIqLr5dRfBGAgACxNQA=
Date: Thu, 9 Aug 2012 17:09:35 +0000
Message-ID: <FF8AA703-9B2B-46B4-9637-8A7FCF92BC78@netflix.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com>
 <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
 <5022CC99.30103@redhat.com>
 <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
 <5022D29B.9000402@redhat.com>
 <C8AA8C7B-505E-49E8-AE47-C24843E74543@netflix.com>
 <50235A25.6010705@redhat.com>
In-Reply-To: <50235A25.6010705@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.229.146]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=windows-1252

On Aug 8, 2012, at 11:35 PM, Milan Broz wrote:

> On 08/09/2012 02:40 AM, Wesley Miaw wrote:
>> 
>> 
>> This isn't as polished because I pretty much just added support to do
>> what I needed. I'm not sure if the LKML is the right place to post,
>> so let me know if I should send this somewhere else.
> 
> This is libcryptsetup userspace so better list for this is dmcrypt
> mailing list (and/or cc me, I will handle these changes anyway).

I will continue this thread on the dm-crypt mailing list.

Thanks,
--
Wesley Miaw
--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQEcBAEBAgAGBQJQI+7PAAoJELoPFVk1ivvR4kcH/3UgTH2viOzBYo2VoJdBmefi
NKgW4HCCE0+8D5mxouhdy/0Zt6rtkWcWXyZo6VjLMxNwytis4Y3Yg2m4FfmqwkJG
xjQ50iJZ7t4qSEEOVvzeSrrECceNEbellDYFWH+V+7N3G09XE40SGNQsHFeJnzQz
fnzjkrx8yNC6xXuVLttZU0sYLvCTBWxcPkVdInb+DNgUUJ9tyIGx36n+4RSgYyl0
ft9VplC1oiAlAX8J2ob/lvvS2ehKXWOnqk770ocGR9/ktibSlMO+dkvo14IZDQqc
dF/lDKbtXljBhlUh8ekIjX29O0lXCgRv9LM1Hnb3ajyd3pdkRD5/SxK6dxahTHQ=
=eXHf
-----END PGP SIGNATURE-----

--Apple-Mail=_140D9E51-76C0-43C6-8922-88E514F61E58--
