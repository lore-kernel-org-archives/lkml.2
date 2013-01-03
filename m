Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3ACK4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:56:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55082 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3ACK4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:56:52 -0500
Date: Thu, 3 Jan 2013 21:56:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20130103215642.b7f641ecc107fd65bdd5eefe@canb.auug.org.au>
In-Reply-To: <20130103083155.5cc97c31@mschwide>
References: <20130103120650.a19cea9d14a664893c0a5e30@canb.auug.org.au>
	<20130103083155.5cc97c31@mschwide>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Jan_2013_21_56_42_+1100_3rX9KnasWlg6H1_c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2013_21_56_42_+1100_3rX9KnasWlg6H1_c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Thu, 3 Jan 2013 08:31:55 +0100 Martin Schwidefsky <schwidefsky@de.ibm.co=
m> wrote:
>
> I surprises me a bit that there is only one hunk in the cleanup patch.
> I expected three, the above for virtio_ccw.c, one for irq.c and another
> for irq.h. I checked the resulting tree which is correct! The merge diff
> has a '++' line for irq.c/irq.h:

Those bits were further down in the mail I sent you (after my signature).

Thanks for checking.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_Jan_2013_21_56_42_+1100_3rX9KnasWlg6H1_c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5WPqAAoJEECxmPOUX5FESTEP/0+bpw+M37ggKflO9qZj8yUf
2DGfIVisEklAUiSDDyQ1WCQKn5V/gSnXCf2PaNi/519Iuox/nALgRW5GvVT+olg7
pK+JA3ZNsSEv3C7VRPseorFvgPAhxBK9pYJUb6Wn3R3pea3/LQTuFLNvcsQz85hb
j+R8weMLm8vrHXi0r5t/+ozY/xNDG1Zb3sEglXJZEmAWxB1EjZsOjgIHoC07zwD6
VlmYaaM1FwVYFL9y3XzXXLw4cdTEdrcKp+2WCt9CZk9LuUrP1SJZ+8k568B0Puf1
PTva/m7zVLxPSFBb8Y5x6+p/51v7X2H+mAfmhpLHOzlVQrS5sEScvCP+fMb6f1sn
3lis1HWyp01j+bVvGI4kwaAw32D1nwV17YicE3XXitBleByeSCHPgbT/vyrip+uc
NFdEqqQM1YjGha0zgeqRBIyNgvm10jxRBNlbNAHqg0IU7RyHKBwBseDQg5uCoE3K
uG6YDezdq0FDHWzZGYVJ5hhy/8TpHv4lGzsc3yFvteAtR63PlI880WfOwaoCkZO9
gS/O0UFZxLurjNafRyTJTd9bkfI8wUqXBAGyQ6ACwUwCD/ueO30PGiLm22AVAe/k
i6esyw+MURnLT11d6JV/otVyTCKFb71V7V2tkkpPCJfMptkw7y8N/nlos41PlU0h
03xhEOjtodg9IFcT0ceN
=axhl
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2013_21_56_42_+1100_3rX9KnasWlg6H1_c--
