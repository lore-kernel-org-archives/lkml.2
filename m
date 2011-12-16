Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab1LPAzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:55:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36842 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab1LPAzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:55:17 -0500
Date: Fri, 16 Dec 2011 11:55:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the target-merge tree
Message-Id: <20111216115508.2ce6cf31f55ddd9a043e8b19@canb.auug.org.au>
In-Reply-To: <CAO+b5-pyo=kR5JuWbQzMd6X70s4AwSWJV7dq3F9BvwLwTDPm7A@mail.gmail.com>
References: <20111215132902.d0a90a93696702e09b0c60bf@canb.auug.org.au>
	<CAO+b5-pyo=kR5JuWbQzMd6X70s4AwSWJV7dq3F9BvwLwTDPm7A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Dec_2011_11_55_08_+1100_e3f9WtBHwFNs9/A6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Dec_2011_11_55_08_+1100_e3f9WtBHwFNs9/A6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Thu, 15 Dec 2011 12:26:49 +0100 Bart Van Assche <bvanassche@acm.org> wro=
te:
>
> The (untested) patch below allowed me to make ib_srpt build again. By

I used that patch as a merge fix up today.

> the way, has the patch "ib_srpt: Make compilation with BUG=3Dn proceed"
> already been queued in the target-merge tree
> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg10030.html)
> ?

It not in the target-merge tree that I have in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Dec_2011_11_55_08_+1100_e3f9WtBHwFNs9/A6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6pbsAAoJEECxmPOUX5FEE4AP/jdIgA3qIk0AMPlavXLnD1ME
0fPk2WTOAVtwTEIAmo/zf7AD7SL+T6tL70mxqdTbMPlwFIB+xK368rhVsKbXP3qk
6bXw1FMjpc1qdwAxXMgRpgbXI7VODlZsjf3RkQuCi2g5QTftxe1VvVcqbosP+CQC
z+wlG070a2rYvyfkzfxVGpj/KEt/QzJcrjsKYDgrAl6ZOIKhPcdJmHOhQdLsb0si
RKEtTA3Y+92V4oGqVSToBGZ+Rfz3kdg7QPbeBYgD9b8rOF2yuhx67Px1SS3Tu3fb
3i3K/kn8ftQWj9UB2M9FYV0oyngfbtynIb+SCQbF5X3f/2lH3iUopE8xMcJbzUFo
zKO7pZvd71lK75jN4n6glq1Z1bTWrpzz1ftLHvbFBcgZVPc2uny92CDMv2NyoUkA
1o3ck9LABpBCoCKE3zj4JXxnNbZXplOwcO1bNG4F1aFSgcDdqHHFtYpavgSSXzC0
czsncrdp0BT0BzkoRTw+LyT6bJk/VO8yWdcAbbc6LmdkQbrsHVpmzZBlsrGv1dUN
TavNlpxEQxwOzVUhPj4domNgpcfDhEvdSdHRvSpY9Xm4rh5G9MCtcd9rA0H9xjrD
VZRcOcEtQSUdACNZkTRJj/D0JtRlC83Vk/CI/0JLNLzh6DktJdd2oyGxcuLAyvDt
lrTOzpDvWvO3u/CQ139S
=VoI1
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Dec_2011_11_55_08_+1100_e3f9WtBHwFNs9/A6--
