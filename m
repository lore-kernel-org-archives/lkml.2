Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683Ab2HIOid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:38:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2HIOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:38:31 -0400
Date: Thu, 9 Aug 2012 16:38:27 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] ALSA: hda - Deferred probing with
 request_firmware_nowait()
Message-ID: <20120809143827.GA10471@avionic-0098.mockup.avionic-design.de>
References: <s5hd3302ovw.wl%tiwai@suse.de>
 <s5ha9y42os2.wl%tiwai@suse.de>
 <5023BAA0.1080304@canonical.com>
 <s5h4noc2ntn.wl%tiwai@suse.de>
 <s5h1ujg2nm7.wl%tiwai@suse.de>
 <5023C0FC.2030207@canonical.com>
 <s5hsjbw17r0.wl%tiwai@suse.de>
 <s5hpq7017gw.wl%tiwai@suse.de>
 <20120809142536.GA1771@avionic-0098.mockup.avionic-design.de>
 <s5hhasc16d9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <s5hhasc16d9.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:AtZCz+XSPHyrIoi/0hmMnWVP+UtA9ZtLAAqIsHBIUD9
 8LP2H8a/ef/WqUZTutrRWfm7hXUoJk2BsBMQaXUxNU4nWZCddV
 t/G3rwAXdEnFXtgugT185awtXh0YecW6xIZxq9rn+NwHQY3AKT
 IkQmpLloMZE8FHykUUaaRXulKHfKbww0JsrOvQVZkYmlqWRXIG
 cnj059YMZ8CuIor8hNF4s62dwzCndLUm2EqjlTNYYhBabGCBuI
 axr8ZpFVZav1S7JEysbKGTKBZPWRHgjsCqiRZ9+pg6fovtdWRV
 UeF/OgC+stw9tEGvkzt+bWruhgxqYHZ4ZeIzo195E/cOg8sEr5
 NkyfM1SUViQZRZEnkGGhGg8j8M1QHp6w9s3hGxvTJBDBwrmBoJ
 3/FLqycUHW5ZCfLVRXgnjRsVz/Sv49Undg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 04:34:42PM +0200, Takashi Iwai wrote:
> At Thu, 9 Aug 2012 16:25:36 +0200,
> Thierry Reding wrote:
> >=20
> > On Thu, Aug 09, 2012 at 04:10:55PM +0200, Takashi Iwai wrote:
> > > For processing the firmware handling properly for built-in kernels,
> > > implement an asynchronous firmware loading with
> > > request_firmware_nowait().  This means that the codec probing is
> > > deferred when the patch option is specified.
> > >=20
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > > v1->v2: drop superfluous chip->probe_deferred field
> > > v2->v3: fix missing chip->fw; renamed the variable to "probe_now"
> > >=20
> > >  sound/pci/hda/hda_codec.c |  2 +-
> > >  sound/pci/hda/hda_intel.c | 42 +++++++++++++++++++++++++++++++++++++=
+----
> > >  2 files changed, 39 insertions(+), 5 deletions(-)
> >=20
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Thanks, now pushed to sound git tree for-next branch.
> As mentioned earlier, this is planned for 3.7 merge.
>=20
> Also, the patches are found in topic/hda-probe-defer branch so that it
> can be easily pulled to 3.6 kernel cleanly.

Great! Thanks,
Thierry

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI8tjAAoJEN0jrNd/PrOhNO0P/0gIBluxOk+wsjxK6JO1lOa4
/e28QygkZ1UhPPniKnIbk4xP7vgoXEKKCsokhK5LRI0wkLTRVifziKXJRHr/MrD7
FNGxYv7gbyVUt5HTdNaqwSdx02VrRYt0Nb/7vkDMLAUApHFw59OET5yY/Qw1JFhO
Glf5Wwq4d40Ma9dvNZWRS/D168yPBqc4B+uUawndafYaw6DGVzUBmlhcXMUwaBho
5Yvz6LUzozDhs7XAmrzbHmELiCUIvUZYkXprggFGXaqknMAbjaMaJWBEgQ0PZUnx
dQr+1oDjYr8kVGUNe5+ZD+HYF3cH7Im37RWFSrRAymrLim5rUl/7CXcESIl4qRNr
mEdZnEu+SIOLMfR8aS37I5XIanIEBMy75zCsU3UD5y5KImSi8VxX7qEbg9Ek9u2z
KDVSLsPY1GfBeNzMQtvDsdVecvSgiTFg3ZeJARhTd6MVEHsRDLbSISKJZT4eDOJZ
T67o6XKV0glYx6P3c79i5p9Br/XXk9L8LUI14h3EyihWiASDODKeGIEInMNplu/B
sYzJhzBOpx/oSI1s9KR6GX9P6L9boN9qUUDxDwLWr9aw6iQe2rSBgACfeIziW/xR
C4bjECqTf4aBKjqP05Oi7Qz/1p+/LJ6EZRniaR+UCpeF7HIPuDRNJ1yQ/ltlVcWB
C7P2t0xFY5A/2VGYuLo1
=7nMB
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
