Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030498Ab2HIO0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:26:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2HIO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:26:10 -0400
Date: Thu, 9 Aug 2012 16:26:02 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>
Subject: Re: [PATCH 1/2] ALSA: hda - Load firmware in hda_intel.c
Message-ID: <20120809142602.GB1771@avionic-0098.mockup.avionic-design.de>
References: <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
 <s5hd330frn1.wl%tiwai@suse.de>
 <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de>
 <s5h7gt8fr47.wl%tiwai@suse.de>
 <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de>
 <s5hzk64earo.wl%tiwai@suse.de>
 <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de>
 <s5hobmk2ql5.wl%tiwai@suse.de>
 <s5hd3302ovw.wl%tiwai@suse.de>
 <s5hboik2otu.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <s5hboik2otu.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:0taG86mocVOk5MWZ2VOHLGrMzgCDnxrT3nPVaevMtZ1
 rUZbcp0ldgCvnHoPIF9kjTsGCp4qn3A3UoNYQBKhZHabOY42jL
 0HVqqbtQN5TQ4NT5Vgmh0gzakin/72ARH+aBcXlFWv71bBjgvm
 /QV3A1ejucep7z016RH0gKrhLnKONgsaKts+QAUsC43Ito213z
 Bg5sv6OQXggQYlLFGoevECBePfJrWl46zr+EXmacnplqS3o/OZ
 T1sxiQvPUTWQ0XUEC21lKTjZME9h+tBuH7IEa9aGF2PRCsqGNs
 rQbumpLoZYiPD+V3CbyskC169qhhEtMgp0fqLZLuLnrGKc8lTm
 Vq3NL7DzeTbPp1xwQAHb3L0u1gOFUqQ3D2LD7PKJqVxJbXsMkf
 xpLRJdrr1F/SZ9rDfe5wKYfXavUkJJbQc3s3tSB0Bk0CSZYvRZ
 SQfKO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 03:10:37PM +0200, Takashi Iwai wrote:
> This is a preliminary work for the deferred probing for
> request_firmware() errors at init.
>=20
> This patch moves the call of request_firmware() to hda_intel.c, and
> call it in the earlier stage of probing rather than
> azx_probe_continue().
>=20
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/hda_codec.h |  2 +-
>  sound/pci/hda/hda_hwdep.c | 39 +++++++++++++--------------------------
>  sound/pci/hda/hda_intel.c | 29 ++++++++++++++++++++++++-----
>  3 files changed, 38 insertions(+), 32 deletions(-)

Tested-by: Thierry Reding <thierry.reding@avionic-design.de>

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI8h6AAoJEN0jrNd/PrOhh8AQAJ4M88lL8CcMbQf9lpn68t7o
I8j36GbcC7ixXc8d1Audvd4gS2ZTLa0AGQY3XJsCXShKiI+BFIDxYIz75lIrMhyK
RtKXXAfJY1lWLriDi6EaOBRSnnXCDXctKFrOBbsNZJL8rry6DgRh15J2H8/QZT8/
SEcaGKgjGbeBYs1OyP3+zRPejwKDKvHMp9/J76noNX6WZRh0FD6Qc8L6mJir6KXy
GQtiHeipyliikqNC+85C6to1d4Tp7tOZRk8wlKdw5uLT/fUvrYEYnpwtReTa/Zqt
1DpY/FFLjJzPg/shkt80ZY+wa5FRoGHVV+kadeSu17FWQm/Q4IOFGCfH0t74pOWn
zbnNJUT4zrf3BhcThYyXcE58YoOOaC5tgfrbfuNR4GRsAqCKwtbdWdAf588IUBa/
OFItZyBgVWwHtEbtjyBu7+vxRDBjyzq+b7xZP3XT1VGnrCYJ+Qs6B+dUuk1wm5mG
xKWatr6+Xx5Upl0znTsZnpOIPZXmwRnpOefX2/4gGdWseICL26KVKffmuw8jInGb
PaHy1MVWBcQwIsiucgQXi+jwrA8pJsim1pQ82E8x+dBbYEeiEtPFIAl8TRSx3K93
1UUqa9ZRCsZgq/vTRtp8Ff9i1PVUtXgg+805cMgz2vlEdoLPi4RYJueOiL06W7qd
4MPFVobllzjSW9Q3qCm+
=sIjn
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
