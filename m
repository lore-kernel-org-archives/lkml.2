Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1KBRUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:20:21 -0400
Received: from home.keithp.com ([63.227.221.253]:33902 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab1KBRUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:20:20 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/7] drm/i915: Try harder during dp pattern 1 link training
In-Reply-To: <e39f63$2h6thv@fmsmga002.fm.intel.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-7-git-send-email-keithp@keithp.com> <e39f63$2h6thv@fmsmga002.fm.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:20:16 -0700
Message-ID: <yunipn2wien.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 09:12:13 +0000, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> This would seem to be a separate chunk to initiate training on only the
> lanes we intend to use.

Yeah, this got left in during some debugging; it might be a good thing
to do, but it's completely separate. I've pulled it out into a separate
patch.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF70DYtFsjWk68qAQgHeQ/8DXmlg+aqvP3svwI+Lo5BC15y8Iw+0eNF
AXcT32DjoVaks0otP4T4rkpuNkT+EZMR3XBGXgZ2kMJVdfvGMdKcwXGANsqXmA6b
zF3GQM287grtHgOlbOWAteQImJk59sxgqI8AJ2JLmiTEAIky5nLdcahPgu6SPUiD
VRZovYd6AX/t7oteMZePwPC2WYJ3SciRAYnlz8KTodOek/KvNEu1y/lVkBCl1/FL
gtlh5h4JSGsN4SCBWIgFfqrQ7IoVBBkOAzFFFYnffeT2tfevuCCp9PNIENm2DSls
EzSVGwhdcxR2I5x6cGOPMkx2ZjowyZZcHRqtbyFqagoIqPUuFOxJkuROSZYk90aW
QMUg2PiEJXFCbVSj6Kg+64JlNfO3RAbIF+TrmP9OxWCN9UX7WPrWcFR5goiXNz/C
f7cbw2RTMicqcOX9RBQKqP0zEvqa9fEzu/uo/LsQZW70MdSImJmru+E0TETuFPT7
tQcCV6PQS/xeVwVR3WLMT48gCegAZMM0zP2irSPybWNjVzVpYBXbLTwPfmlvKr05
HB0Riq5XcSFFmnE19h4hEnW17DllsiO1YrlaWR1gMTsHDteMV67jfDFDnlVsGYY9
+1ioaPhkIEtM2CeB5gSJJC5ELh4+LimroJOpY+GzG6pST0plKHiLTtNZnjRkvRP9
bemjmCkmFvA=
=a1Ve
-----END PGP SIGNATURE-----
--=-=-=--
