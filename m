Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0GWLb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:31:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0GWLb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:31:57 -0400
Date: Fri, 23 Jul 2010 21:31:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Message-Id: <20100723213148.3d2193a3.sfr@canb.auug.org.au>
In-Reply-To: <4C497CD5.5010908@kernel.org>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
	<4C497CD5.5010908@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_21_31_48_+1000_jfrIcfLvLeaDQkam"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_21_31_48_+1000_jfrIcfLvLeaDQkam
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Fri, 23 Jul 2010 13:28:21 +0200 Tejun Heo <tj@kernel.org> wrote:
>
> Yes, one failure case is removed, so that would be correct.

Thanks for the confirmation.  This should probably be fixed in the
workqueues tree before it is merged upstream.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_21_31_48_+1000_jfrIcfLvLeaDQkam
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSX2kAAoJEDMEi1NhKgbscrYIAIo8YCviRQYeY/ZIBc8c+L0O
Hjg3ZSHSVJfq/WlYwJDv1fBl2MLm1bQCTdoAXbw01HSO5Qmi3WrYj8dxWELPWUAz
rGck1+yHLK4TzG/TGsD1MqvnrhdbGjG6Q5OhZrrzRNVDe/eHrLc1jbs1M5DnF82u
gOV8sZBF34iL91IX91dOs9/pe+olzduRe6psnR5VR6t7MLKkFme3ZapkEmpjleWn
np67YS32cOc8n1vfAFRSzODPZMaOzXIcVq2aH4tEuA0NhXHNzTbaXMs6ih2okK34
DtayFwN93cqinfJVjnyW/I3euaA7PxazPD21jGs0Km4O50a8pQTISh6fuWl17nU=
=SRRp
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_21_31_48_+1000_jfrIcfLvLeaDQkam--
