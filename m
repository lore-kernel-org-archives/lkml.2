Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1BJDze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:55:34 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52007 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1BJDzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:55:32 -0500
Date: Thu, 10 Feb 2011 14:55:28 +1100
From: Stephen Rothwell <sfr@au1.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the xen-two tree with the tip tree
Message-Id: <20110210145528.95c90b63.sfr@au1.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Feb_2011_14_55_28_+1100_qyFY07p2UL58zaqe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Feb_2011_14_55_28_+1100_qyFY07p2UL58zaqe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
kernel/irq/manage.c between commit
dc5f219e88294b93009eef946251251ffffb6d60 ("genirq: Add
IRQF_FORCE_RESUME") from the tip tree and commit
c6c5596743c2a333a8e31b0247f44cd367484a5e ("genirq: Add
IRQF_FORCE_RESUME") from the xen-two tree.

Despite having the same Author time stamps, these commits are not quite the
same.  I used the version from the tip tree which kept the line:

		desc->status &=3D ~IRQ_SUSPENDED;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Feb_2011_14_55_28_+1100_qyFY07p2UL58zaqe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNU2GwAAoJEDMEi1NhKgbsHJ8IAIvoYEdoob1NyNO0hrKm/nV5
OzzPpigLFxeIcRBil5QOep7LCceNyfqwu73azYffSaZ0HLHyV+EplJVnNKFrONCb
OthgnQqqo40oEtXDzZsiggZzNqP+9nZa+vhhv4kzE/f2orWHM4vXVQrGFODT1LKP
QdnO8LejbuWbaxB7CoHIwbKZKhJbOlTQ0N0YyQEHIOhtFvWM60Y9Xe5Ty4sjfa2B
Ny7DU9Ez3VmeJjfQ7Aqb2T/ZQaQrbLng1P5n8ALU2rrQOq2weLpyVnu2kxWCyWvd
ObgFvSJ5jbJTITmE/svckgVJ/6ffZykh1ICXtZZJGWEZYu8tweFgaWcMVaGbW/E=
=+cDo
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Feb_2011_14_55_28_+1100_qyFY07p2UL58zaqe--
