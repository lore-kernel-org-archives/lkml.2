Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1IPQa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:30:56 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:33944
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab1IPQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:30:55 -0400
X-IronPort-AV: E=Sophos;i="4.68,394,1312149600"; 
   d="bad'?good'?scan'208";a="109369925"
Date: Fri, 16 Sep 2011 18:30:50 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20110916163050.GT4891@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110914232717.GA5410@type.famille.thibault.fr>
 <yunobym743b.fsf@aiko.keithp.com>
 <20110915074106.GA4544@type.famille.thibault.fr>
 <20110915081259.GB4877@type.bordeaux.inria.fr>
 <yunlitp7umf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yunlitp7umf.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Keith Packard, le Thu 15 Sep 2011 09:22:48 -0500, a écrit :
> On Thu, 15 Sep 2011 10:12:59 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> 
> > At home only. At work, with a different VGA screen, I'm still getting
> > the issue.
> 
> You're still having a problem with the LVDS screen at work with FBC
> disabled?

Yes, though it now seems random, sometimes it works, sometimes not.

> Can you send along a kernel log with drm.debug=5?

Here they are.

Samuel

--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.bad"

5b, dev 0xe200, auth=1
[   40.384083] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.384093] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.386952] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.386989] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.386999] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.389612] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.389650] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.389662] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.391988] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.392023] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.392033] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.395432] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.395464] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.395473] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.398397] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.398433] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.398444] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.401377] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.401409] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.401419] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.404118] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.404148] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.404158] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.407356] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.407386] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.407397] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.410284] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.410314] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.410324] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.413242] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.413272] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.413282] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.416177] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.416206] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.416216] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.419170] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.419200] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.419210] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.422059] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.422104] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.422116] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.425187] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.425219] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.425229] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.427927] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.427956] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.427967] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.432075] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.432105] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.432116] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.434640] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.434677] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.434689] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.437481] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.437519] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.437531] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.440283] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.440313] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.440323] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.443076] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.443106] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.443116] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.446472] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.446502] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.446512] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.449469] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.449499] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.449509] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.452165] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.452194] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.452204] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.455314] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.455344] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.455354] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.458055] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.458084] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.458094] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.460587] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.460615] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.460625] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.463406] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.463435] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.463445] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.466369] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.466399] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.466409] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.469356] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.469386] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.469396] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.472144] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.472174] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.472184] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.474851] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.474880] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.474890] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.477786] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.477824] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.477835] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.480729] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.480771] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.480786] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.483836] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.483866] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.483877] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.486794] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.486824] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.486834] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.489734] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.489764] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.489775] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.492825] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.492855] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.492865] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.499798] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.499828] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.499838] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.502828] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.502858] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.502868] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.505313] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.505351] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.505363] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.508339] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.508369] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.508380] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.510703] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.510733] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.510743] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.513145] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.513182] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.513194] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.515592] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.515626] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.515636] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.518494] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.518524] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.518534] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.521648] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.521685] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.521697] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.524539] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.524592] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.524607] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.527372] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.527412] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.527422] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.533661] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.533691] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.533701] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.536183] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.536213] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.536222] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.539479] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.539509] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.539519] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.542037] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.542066] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.542076] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.545442] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.545473] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.545483] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.548714] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.548744] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.548755] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.548798] [drm:drm_vm_open_locked], 0x7fed8065d000,0x00001000
[   40.548807] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.551443] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.551473] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.551483] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.554705] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.554743] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.554754] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.557116] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.557161] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.557172] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.559310] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559330] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559360] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559372] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559390] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559402] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559419] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559431] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559448] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559460] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559477] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559489] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.559506] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.559518] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562079] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.562110] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.562120] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.562236] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562249] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562270] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562282] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562298] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562309] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562326] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562337] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562354] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562365] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562383] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562394] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562411] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562422] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.562439] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.562451] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.563290] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.563319] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.563329] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.565241] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.565270] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.565280] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.566911] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.566941] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.566951] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.568448] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.568477] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.568486] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.569985] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.570014] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.570024] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.570113] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570126] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.570147] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570160] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.570178] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570189] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.570207] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570218] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.570235] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570247] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.570264] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.570275] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.571144] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.571172] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.571182] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.572719] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.572759] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.572774] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.574469] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.574499] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.574509] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.574622] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.574635] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.574656] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.574668] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576392] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.576421] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.576431] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.576585] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576606] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576636] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576653] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576678] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576696] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576720] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576737] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576761] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576777] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576802] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576819] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.576843] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.576859] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.578230] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.578260] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.578270] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.579278] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.579307] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.579317] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.580764] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.580793] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.580803] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.581820] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.581848] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.581857] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.583199] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.583227] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.583236] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.584553] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.584590] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.584605] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.584760] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.584782] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.584815] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.584834] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.586213] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.586243] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.586253] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.586365] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.586378] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.586399] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.586410] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.586427] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.586439] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.586456] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.586467] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.586484] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.586496] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.587524] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.587553] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.587562] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.588633] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.588669] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.588683] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.590583] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.590611] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.590621] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.591566] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.591594] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.591604] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.594224] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.594253] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.594263] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.594374] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.594387] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.594409] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.594420] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.595912] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.595941] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.595951] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.596062] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.596074] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.597832] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.597862] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.597872] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.597988] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.598002] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.598024] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.598036] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.598053] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.598064] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.598082] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.598093] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.598959] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.598988] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.598998] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.602531] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.602562] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.602572] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.604037] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.604066] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.604076] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.605832] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.605872] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.605883] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.605993] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606006] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606028] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606040] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606058] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606070] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606087] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606098] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606114] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606126] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606142] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606154] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.606171] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.606182] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.607445] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.607483] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.607494] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.609104] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.609139] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.609172] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.610843] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.610881] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.610893] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.611023] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611036] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611058] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611070] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611087] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611098] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611115] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611126] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611143] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611154] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611171] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611183] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611199] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611210] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611227] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611238] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.611254] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.611266] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.612002] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.612028] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.612038] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.613167] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.613204] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.613216] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.614933] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.614960] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.614970] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.616357] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.616381] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.616390] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.617901] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.617928] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.617938] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.618040] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.618053] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.618075] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.618087] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.618105] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.618123] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.618141] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.618152] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.618169] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.618180] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.619468] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.619493] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.619502] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.619599] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.619611] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.619631] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.619642] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.619659] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.619671] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.621063] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.621099] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.621130] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.622338] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.622374] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.622385] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.623651] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.623676] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.623686] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.623763] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.623777] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.623799] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.623811] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.625311] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.625349] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.625360] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.625490] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.625503] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.625525] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.625537] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.626887] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.626914] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.626923] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.628143] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.628167] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.628177] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.628272] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.628284] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.629740] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.629767] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.629776] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.629879] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.629891] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.629911] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.629923] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.629940] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.629952] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.629968] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.629979] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.629995] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630013] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.630030] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630041] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.630058] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630069] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.630086] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630097] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.630113] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630124] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.630140] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.630151] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.631407] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.631431] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.631440] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.632861] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.632900] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.632911] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.633050] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.633063] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.633087] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.633098] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.634396] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.634435] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.634446] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.636507] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.636549] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.636565] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.636699] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.636713] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.638832] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.638872] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.638883] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.639014] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.639027] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.639048] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.639060] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.639078] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.639090] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.639106] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.639961] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.639981] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.639990] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.641779] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.641818] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.641829] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.655105] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.655143] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.655155] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.655199] [drm:drm_vm_open_locked], 0x7fed8065c000,0x00001000
[   40.655210] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.655338] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.655352] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.655374] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.655386] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.655403] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.655415] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   40.657414] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.657454] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.657465] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.679083] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.679112] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.679133] [drm:drm_vm_open_locked], 0x7fed80661000,0x00001000
[   40.679144] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.679231] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.679241] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679281] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.679293] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.679311] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.679327] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.679355] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.679478] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679489] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679499] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679508] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.679520] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679550] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.679561] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.679590] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679599] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.679607] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.679656] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.681194] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.681207] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.681235] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.681245] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.681255] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.681283] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.690425] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.690442] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690474] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.690486] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.690504] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.690513] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690522] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.690534] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.690608] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690620] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690629] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690638] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.690648] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690675] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.690685] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.690712] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690722] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.690730] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.690777] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.691645] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.691668] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.691688] [drm:drm_vm_open_locked], 0x7fed80660000,0x00001000
[   40.691698] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.691739] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.691750] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.691773] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.691783] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.691791] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.691805] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.691813] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.691841] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.691857] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.691871] [drm:drm_vm_open_locked], 0x7fed8065f000,0x00001000
[   40.691880] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.691946] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.691957] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.691966] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.691976] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.691985] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.691996] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692046] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692057] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692066] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692075] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692085] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692100] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692110] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692133] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692142] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692150] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692159] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.692229] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.692254] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692263] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692277] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692287] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692296] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692305] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692313] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692323] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692384] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692400] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692413] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692426] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692442] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692456] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.692516] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.692554] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692570] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692595] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692609] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692621] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692639] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692651] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692705] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692720] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692734] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692746] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692760] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692774] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692822] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692837] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692851] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692864] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692879] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692897] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.692910] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.692937] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692950] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.692963] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.692976] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.692998] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.693022] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.693035] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693053] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.693066] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.693079] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.693092] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693104] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.693118] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.693158] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693168] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693176] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693185] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.693195] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.693204] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.693222] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.693240] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.693599] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.693890] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.694180] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.694463] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.694480] [drm:drm_ioctl], pid=4148, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   40.694492] [drm:drm_ioctl], pid=4148, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   40.697787] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.697913] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.698019] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.698119] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.698221] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.698314] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.698336] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.698375] [drm:drm_vm_open_locked], 0x7fed8065b000,0x00001000
[   40.698386] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.698434] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.698444] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698464] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.698475] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.698484] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.698493] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698501] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.698513] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.698569] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698580] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698589] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698598] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.698609] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.698622] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.715167] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.715249] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.715332] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.715342] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715365] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.715377] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.715387] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.715396] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715405] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.715417] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.715471] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715482] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715491] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715501] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.715511] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.715523] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.717869] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.717883] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.717908] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.717919] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.717929] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.717937] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.717946] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.717957] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.718005] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718016] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718025] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718034] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718045] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718078] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718088] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.718116] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718125] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718133] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718146] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718154] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718208] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718218] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718227] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718236] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718246] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718256] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.718302] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718313] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718322] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718330] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718341] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718355] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718365] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.718388] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718397] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718406] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718415] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.718435] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.718458] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718467] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718481] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718491] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718500] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718508] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718517] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.718527] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.718562] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718572] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718581] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718590] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.718600] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.718609] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.718627] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.718643] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.737528] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.737549] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.737559] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.737565] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.737571] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.737589] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.737592] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737597] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.737600] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.737602] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.737604] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737606] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.737609] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.737623] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737626] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737628] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737630] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.737633] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.737636] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803000] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.803037] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   40.803066] [drm:drm_vm_open_locked], 0x7fed8065a000,0x00001000
[   40.803081] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.803140] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.803153] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.803191] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803202] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803210] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803254] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803263] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803289] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.803299] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.803309] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803319] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803328] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.803339] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.803391] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803402] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803433] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803443] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803454] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803473] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.803483] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.803508] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803517] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.803525] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.803646] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804530] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804546] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804553] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.804556] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.804558] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804561] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804563] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.804566] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.804628] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804639] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804670] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804685] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804699] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804756] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.804775] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.804808] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804821] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804834] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804868] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.804896] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.804914] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804924] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.804933] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.804969] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.806018] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806065] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806078] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806089] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806100] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806110] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806202] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.806212] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806426] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.806442] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.806452] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.806461] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806470] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.806482] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.806527] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806537] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806569] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806579] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.806590] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   40.806623] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.806642] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.806692] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806701] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.806709] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.806718] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806740] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806751] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806761] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806772] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806782] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.806803] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.808634] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.808647] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.808837] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.808852] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.808863] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.808872] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.808882] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.808893] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.808939] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.808949] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.808987] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.808996] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809005] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809026] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809035] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.809064] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809073] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809080] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809088] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809109] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809119] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809130] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809139] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809149] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809186] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809195] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809395] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809410] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809420] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809427] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809457] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809468] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.809507] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809516] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809541] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809551] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809559] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809580] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809599] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.809625] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809633] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809640] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809649] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809669] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809679] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809690] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809699] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809708] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.809940] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.809952] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.809974] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.809983] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.809992] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810056] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810074] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.810117] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810120] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810141] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810170] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810180] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.810199] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810208] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810216] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810234] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810244] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.810261] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810270] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810281] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810299] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810309] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.810326] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810335] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810344] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810381] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810546] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810583] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810594] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810604] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810613] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810623] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810633] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810642] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810652] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810662] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810671] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.810721] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810731] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810766] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810777] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810786] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810795] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810804] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.810814] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.810856] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810866] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810895] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810905] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.810914] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.810944] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811072] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811075] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811107] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811118] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811126] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811164] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811174] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811193] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811202] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811210] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811241] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811251] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811269] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811278] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811287] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811304] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811314] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811331] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811340] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811350] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811368] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811378] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811394] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811404] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811412] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811442] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811572] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811598] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811609] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811619] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811628] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811638] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   40.811686] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811695] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811730] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811740] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811750] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811758] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811767] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   40.811778] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   40.811819] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811829] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811858] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811868] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   40.811877] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   40.811906] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.471618] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.471639] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.471684] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.471701] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.471716] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.471729] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.471743] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.471759] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.471830] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.471845] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.471895] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.471909] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.471963] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.471980] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472156] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.472174] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.472217] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472232] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472244] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472281] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472293] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472329] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.472344] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.472358] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472372] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472384] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.472400] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.472464] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472479] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472515] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472530] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472544] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472604] [drm:drm_ioctl], pid=4148, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   42.472633] [drm:drm_ioctl], pid=4148, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   42.472656] [drm:drm_vm_open_locked], 0x7fed80659000,0x00001000
[   42.472670] [drm:drm_ioctl], pid=4148, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   42.472725] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.472740] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.472778] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472793] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472806] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.472841] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.472855] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.475545] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.475572] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.475655] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.475675] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.475793] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.475811] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.475864] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.475882] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476075] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476098] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476159] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476178] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476339] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476359] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476418] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476429] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476450] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476463] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476557] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476569] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476598] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476610] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476737] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476750] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476793] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476805] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476832] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476845] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476942] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.476954] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.476999] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477011] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477051] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477063] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477155] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477167] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477196] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477208] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477290] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477301] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477334] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477346] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477369] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477381] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477410] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477422] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477464] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477475] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477511] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477523] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477550] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477562] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477606] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477618] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477644] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477663] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477695] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477707] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477729] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477763] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477775] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477811] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477823] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477879] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477896] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477920] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477936] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.477962] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.477996] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478012] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478063] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478079] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478118] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478134] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478285] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478303] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478326] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478342] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478368] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478381] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478400] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478412] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478431] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478443] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478467] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478478] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478496] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478508] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478526] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478538] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478560] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478572] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478589] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478601] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478626] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478641] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478663] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478674] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478690] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478703] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478723] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478735] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478752] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478765] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478785] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478797] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478813] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478826] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478866] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478879] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.478901] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.478913] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.478925] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.478936] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.478946] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.478970] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.479026] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479041] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479162] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479174] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.479186] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479353] [drm:drm_ioctl], pid=4148, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   42.479366] [drm:drm_ioctl], pid=4148, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   42.479398] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479408] [drm:drm_ioctl], pid=4148, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   42.479417] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.479568] [drm:drm_ioctl], pid=4148, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   42.479584] [drm:intel_crtc_cursor_set], 
[   42.479591] [drm:intel_crtc_cursor_set], cursor off
[   42.479602] [drm:drm_ioctl], pid=4148, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   42.479616] [drm:intel_crtc_cursor_set], 
[   42.479623] [drm:intel_crtc_cursor_set], cursor off
[   42.738878] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738895] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738909] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738919] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738937] [drm:drm_ioctl], pid=4148, cmd=0xc01064ab, nr=0xab, dev 0xe200, auth=1
[   42.738949] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738957] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738966] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738975] [drm:drm_ioctl], pid=4148, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   42.738995] [drm:drm_ioctl], pid=4148, cmd=0xc01064ab, nr=0xab, dev 0xe200, auth=1
[   42.739049] [drm:drm_ioctl], pid=4148, cmd=0x641f, nr=0x1f, dev 0xe200, auth=1
[   42.739070] [drm:drm_ioctl], pid=4148, cmd=0xc00464af, nr=0xaf, dev 0xe200, auth=1
[   42.739078] [drm:drm_ioctl], ret = fffffff3
[   42.739115] [drm:drm_vm_close_locked], 0x7fed7ae03000,0x00400000
[   42.739125] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739155] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739168] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739177] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739186] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739201] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739220] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739232] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739246] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739258] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739271] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739283] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739296] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739308] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739322] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739334] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739347] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739358] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739388] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739410] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739432] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739449] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739470] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739496] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739517] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739534] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739555] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739572] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739593] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739610] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739631] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739647] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739668] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739685] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739706] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739721] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739738] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739759] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739777] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739797] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739814] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739836] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739853] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739874] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739890] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739911] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739928] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739949] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.739966] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.739987] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740003] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740024] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740041] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740061] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740078] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740098] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740115] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740136] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740153] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740173] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740190] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740211] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740227] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740248] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740264] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740285] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740302] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740322] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740339] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740359] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740376] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740397] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740414] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740435] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740452] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740472] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740489] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740510] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740526] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740547] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740563] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740584] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740600] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740621] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740638] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740658] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740689] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740709] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740726] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740747] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740764] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740784] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740801] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740822] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740839] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740862] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740879] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740900] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740917] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740938] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740956] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.740977] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.740994] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741014] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741030] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741052] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741068] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741089] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741106] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741126] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741143] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741164] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741180] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741201] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741218] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741239] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741256] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741277] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741294] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741314] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741331] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741352] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741369] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741390] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741407] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741427] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741444] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741591] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741615] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741645] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741668] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741694] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741715] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741740] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741761] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741785] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741805] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741830] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741850] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741875] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741895] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741920] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741940] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.741959] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741975] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.741995] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.742014] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742027] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742039] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742051] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742103] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742115] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742125] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742134] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742143] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742153] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742162] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742173] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742183] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.742212] [drm:drm_ioctl], pid=4148, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   42.742222] [drm:drm_ioctl], pid=4148, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   42.750095] [drm:drm_crtc_helper_set_config], 
[   42.750097] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   42.750102] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   42.750104] [drm:drm_mode_debug_printmodeline], Modeline 30:"1152x864" 0 81620 1152 1216 1336 1520 864 865 868 895 0x0 0x6
[   42.750107] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   42.750110] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   42.750112] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   42.750114] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   42.750115] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   42.750122] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   42.750126] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0 : v 5 p(0,888)@ 1316161135.338781 -> 1316161135.322868 [e 0 us, 0 rep]
[   42.805413] [drm:intel_wait_for_vblank], vblank wait timed out
[   42.837796] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   42.837807] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   42.837814] [drm:intel_update_fbc], 
[   42.837817] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   42.837829] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[   42.837836] [drm:ironlake_crtc_mode_set], using SSC reference clock of 120 MHz
[   42.838277] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   42.838483] [drm:ironlake_crtc_mode_set], Mode for pipe A:
[   42.838488] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   42.838805] [drm] Changing LVDS panel from (-hsync, +vsync) to (+hsync, -vsync)
[   42.893316] [drm:intel_wait_for_vblank], vblank wait timed out
[   42.893340] [drm:ironlake_update_plane], Writing base 00063000 00000000 0 0 6400
[   42.893348] [drm:intel_update_fbc], 
[   42.893352] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   42.949221] [drm:intel_wait_for_vblank], vblank wait timed out
[   42.949230] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   42.949238] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   42.949246] [drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:26:1600x900]
[   42.949254] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   42.949260] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   43.005158] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.061087] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.061901] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   43.061908] [drm:gen6_fdi_link_train], FDI train 1 done.
[   43.062562] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   43.062567] [drm:gen6_fdi_link_train], FDI train 2 done.
[   43.062571] [drm:gen6_fdi_link_train], FDI train done.
[   43.063785] [drm:intel_update_fbc], 
[   43.063789] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   43.063803] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 2044, vtotal 930, vdisplay 900
[   43.063811] [drm:drm_calc_timestamping_constants], crtc 3: clock 114060 kHz framedur 16665600 linedur 17920, pixeldur 8
[   43.063823] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[   43.063829] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:LVDS-1] set DPMS on
[   43.063836] [drm:drm_crtc_helper_set_config], 
[   43.063840] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   43.063851] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   43.063856] [drm:drm_mode_debug_printmodeline], Modeline 31:"1152x864" 0 108000 1152 1216 1344 1600 864 865 868 900 0x0 0x5
[   43.063866] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   43.063877] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.063883] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.063889] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   43.063894] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   43.063907] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   43.063918] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 1 : v 5 p(0,715)@ 1316161135.653010 -> 1316161135.642417 [e 0 us, 0 rep]
[   43.116987] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.133391] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   43.133401] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   43.133408] [drm:intel_update_fbc], 
[   43.133412] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   43.133422] [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
[   43.133863] [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH
[   43.134069] [drm:ironlake_crtc_mode_set], Mode for pipe B:
[   43.134074] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   43.188886] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.188897] [drm:ironlake_update_plane], Writing base 00063000 00000000 0 0 6400
[   43.188906] [drm:intel_update_fbc], 
[   43.188910] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   43.244823] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.244833] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   43.244840] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   43.244849] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:27:1600x1200]
[   43.244858] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   43.244864] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   43.300745] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.356653] [drm:intel_wait_for_vblank], vblank wait timed out
[   43.357467] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   43.357473] [drm:gen6_fdi_link_train], FDI train 1 done.
[   43.358127] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   43.358133] [drm:gen6_fdi_link_train], FDI train 2 done.
[   43.358136] [drm:gen6_fdi_link_train], FDI train done.
[   43.359350] [drm:intel_update_fbc], 
[   43.359354] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   43.359363] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 2160, vtotal 1250, vdisplay 1200
[   43.359371] [drm:drm_calc_timestamping_constants], crtc 4: clock 162000 kHz framedur 16666250 linedur 13333, pixeldur 6
[   43.359382] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[   43.359388] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:12:VGA-1] set DPMS on
[   43.359396] [drm:drm_crtc_helper_set_config], 
[   43.359400] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   43.359413] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.359419] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.359425] [drm:drm_crtc_helper_set_config], 
[   43.359428] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   43.359438] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.359443] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.359471] [drm:drm_crtc_helper_set_config], 
[   43.359475] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   43.359484] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.359489] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.359495] [drm:drm_crtc_helper_set_config], 
[   43.359498] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   43.359507] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.359513] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.377410] [drm:drm_crtc_helper_set_config], 
[   43.377416] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   43.377429] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.377435] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.377441] [drm:drm_crtc_helper_set_config], 
[   43.377444] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   43.377453] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.377459] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.397614] [drm:drm_vm_close_locked], 0x7fed80659000,0x00001000
[   43.397624] [drm:drm_vm_close_locked], 0x7fed8065a000,0x00001000
[   43.397632] [drm:drm_vm_close_locked], 0x7fed8065b000,0x00001000
[   43.397667] [drm:drm_vm_close_locked], 0x7fed8065c000,0x00001000
[   43.397673] [drm:drm_vm_close_locked], 0x7fed8065d000,0x00001000
[   43.397678] [drm:drm_vm_close_locked], 0x7fed8065e000,0x00001000
[   43.397684] [drm:drm_vm_close_locked], 0x7fed8065f000,0x00001000
[   43.397691] [drm:drm_vm_close_locked], 0x7fed80660000,0x00001000
[   43.397698] [drm:drm_vm_close_locked], 0x7fed80661000,0x00001000
[   43.397727] [drm:drm_release], open_count = 1
[   43.397734] [drm:drm_release], pid = 4148, device = 0xe200, open_count = 1
[   43.403966] [drm:drm_lastclose], 
[   43.403973] [drm:drm_crtc_helper_set_config], 
[   43.403978] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   43.403994] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.404002] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.404009] [drm:drm_crtc_helper_set_config], 
[   43.404014] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   43.404025] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   43.404031] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   43.404039] [drm:drm_lastclose], driver lastclose completed
[   43.404045] [drm:drm_lastclose], lastclose completed

--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good"

>[   70.681771] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.681802] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.681812] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.685040] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.685076] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.685087] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.687387] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.687416] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.687425] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.691112] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.691141] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.691150] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.693952] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.693987] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.693996] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.696850] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.696879] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.696888] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.699440] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.699468] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.699477] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.701807] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.701836] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.701845] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.705182] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.705212] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.705221] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.708009] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.708042] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.708052] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.710919] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.710947] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.710957] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.713662] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.713699] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.713710] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.716803] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.716833] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.716842] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.719699] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.719731] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.719740] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.722802] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.722830] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.722840] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.725785] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.725822] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.725833] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.728804] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.728833] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.728843] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.731588] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.731620] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.731629] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.734650] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.734679] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.734688] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.737320] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.737348] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.737357] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.741400] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.741437] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.741448] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.743753] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.743785] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.743795] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.746352] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.746381] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.746390] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.748905] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.748933] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.748942] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.751496] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.751524] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.751533] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.754899] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.754930] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.754940] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.757801] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.757830] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.757839] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.760511] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.760539] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.760549] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.763329] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.763357] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.763366] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.766078] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.766106] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.766115] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.768655] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.768692] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.768703] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.771377] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.771406] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.771415] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.774276] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.774305] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.774314] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.777237] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.777273] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.777284] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.780097] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.780138] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.780148] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.782682] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.782711] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.782720] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.785525] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.785553] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.785563] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.788378] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.788406] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.788415] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.791400] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.791428] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.791437] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.794291] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.794319] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.794328] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.797233] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.797270] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.797281] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.800290] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.800320] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.800330] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.806661] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.806690] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.806700] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.809646] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.809675] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.809684] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.812007] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.812043] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.812055] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.814924] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.814951] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.814960] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.817197] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.817233] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.817245] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.819541] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.819570] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.819579] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.821987] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.822015] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.822025] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.824938] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.824968] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.824977] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.827997] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.828036] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.828050] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.830803] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.830832] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.830841] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.833600] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.833636] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.833647] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.840006] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.840042] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.840053] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.842541] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.842570] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.842579] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.845819] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.845856] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.845866] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.848451] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.848487] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.848498] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.851777] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.851806] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.851816] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.855073] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.855102] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.855113] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.855155] [drm:drm_vm_open_locked], 0x7fc83be3c000,0x00001000
[   70.855164] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.857820] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.857848] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.857858] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.861051] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.861090] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.861101] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.863273] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.863313] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.863324] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.865563] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865591] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865627] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865640] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865656] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865668] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865683] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865694] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865710] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865721] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865736] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865747] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.865763] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.865774] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.867830] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.867861] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.867870] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.868054] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868073] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868102] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868120] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868144] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868161] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868187] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868205] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868231] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868247] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868272] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868288] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868309] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868323] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.868346] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.868359] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.869235] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.869264] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.869273] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.870961] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.870990] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.870999] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.872705] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.872733] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.872743] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.874236] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.874263] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.874272] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.875618] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.875645] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.875655] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.875740] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875753] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.875772] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875784] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.875799] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875810] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.875825] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875836] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.875852] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875862] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.875934] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.875954] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.876805] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.876832] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.876841] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.878276] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.878303] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.878312] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.879931] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.879966] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.879979] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.880128] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.880146] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.880166] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.880177] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.881830] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.881859] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.881868] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.881977] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.881990] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882009] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882020] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882037] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882047] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882062] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882073] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882088] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882098] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882113] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882124] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.882139] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.882150] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.883404] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.883432] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.883441] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.884550] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.884578] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.884587] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.885875] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.885903] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.885912] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.886869] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.886896] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.886905] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.888333] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.888359] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.888368] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.889645] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.889672] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.889682] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.889791] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.889804] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.889824] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.889835] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.891163] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.891191] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.891200] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.891308] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.891320] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.891339] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.891350] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.891366] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.891377] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.891392] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.891403] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.891418] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.891434] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.892643] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.892694] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.892710] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.893792] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.893829] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.893840] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.895574] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.895611] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.895622] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.896656] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.896693] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.896704] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.898816] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.898842] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.898851] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.898951] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.898965] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.898985] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.898996] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.900412] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.900449] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.900459] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.900566] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.900579] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.901603] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.901628] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.901637] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.901733] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.901746] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.901764] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.901775] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.901790] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.901801] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.901817] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.901827] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.902482] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.902505] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.902514] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.906117] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.906144] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.906153] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.907429] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.907452] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.907461] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.908937] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.908965] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.908974] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.909058] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909070] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909089] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909100] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909116] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909126] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909142] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909153] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909168] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909178] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909193] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909203] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.909218] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.909229] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.910224] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.910248] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.910257] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.911584] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.911607] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.911615] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.913569] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.913596] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.913605] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.913709] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913722] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913740] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913751] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913767] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913778] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913793] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913803] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913818] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913829] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913844] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913854] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913869] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913880] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913895] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913906] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.913921] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.913931] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.914626] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.914650] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.914658] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.915875] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.915905] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.915919] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.917672] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.917698] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.917707] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.919094] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.919117] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.919126] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.920474] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.920511] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.920522] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.920650] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.920663] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.920683] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.920695] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.920710] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.920721] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.920736] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.920747] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.920763] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.920774] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.922188] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.922214] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.922223] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.922323] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.922336] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.922354] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.922365] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.922381] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.922391] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.923484] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.923507] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.923516] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.924792] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.924827] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.924838] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.926242] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.926279] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.926289] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.926390] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.926402] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.926422] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.926433] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.927930] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.927967] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.927978] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.928104] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.928116] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.928135] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.928147] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.929981] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.930019] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.930030] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.931305] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.931336] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.931345] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.931444] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.931457] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.932989] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.933027] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.933038] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.933166] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933179] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933199] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933210] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933225] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933236] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933251] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933261] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933275] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933286] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933301] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933312] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933327] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933337] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933351] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933362] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933377] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933387] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.933401] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.933412] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.934651] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.934676] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.934685] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.936123] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.936170] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.936189] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.936364] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.936382] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.936408] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.936432] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.937930] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.937958] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.937968] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.939789] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.939835] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.939852] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.939991] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.940011] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.941860] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.941887] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.941896] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.941998] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.942010] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.942028] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.942040] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.942055] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.942066] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.942082] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.942854] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.942872] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.942880] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.944610] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.944647] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.944658] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.954186] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.954222] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.954234] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.954275] [drm:drm_vm_open_locked], 0x7fc83be3b000,0x00001000
[   70.954285] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.954419] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.954431] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.954451] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.954462] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.954477] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.954488] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   70.956548] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.956593] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.956604] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.977528] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.977552] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.977572] [drm:drm_vm_open_locked], 0x7fc83be40000,0x00001000
[   70.977581] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.977678] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.977687] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.977723] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.977734] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.977755] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.977770] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.977797] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.978023] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978034] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978042] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978050] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.978060] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978091] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.978101] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.978130] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978138] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.978146] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.978194] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.979537] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.979549] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.979571] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.979579] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.979587] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.979612] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.988259] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.988273] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988299] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.988310] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.988327] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.988335] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988343] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.988354] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.988453] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988463] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988471] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988479] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.988488] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988513] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.988523] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.988549] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988557] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.988565] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.988609] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989429] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.989449] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.989466] [drm:drm_vm_open_locked], 0x7fc83be3f000,0x00001000
[   70.989475] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.989528] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.989538] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.989560] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989569] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989577] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989590] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989598] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989625] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.989640] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.989654] [drm:drm_vm_open_locked], 0x7fc83be3e000,0x00001000
[   70.989662] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.989738] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.989748] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.989757] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989766] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989774] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.989784] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.989834] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989844] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989852] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989860] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989869] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989883] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.989892] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.989916] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989924] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.989932] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.989940] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990004] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990026] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990035] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990049] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990057] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990066] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990073] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990082] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990091] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.990127] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990136] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990144] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990152] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990160] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990169] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990223] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990252] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990262] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.990281] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990289] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990296] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990308] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990316] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990364] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990374] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990382] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990391] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990399] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990409] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.990453] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990462] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990470] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990478] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990487] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990500] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990509] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.990533] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990541] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990549] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990557] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990575] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990594] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990603] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990616] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990625] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990633] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990641] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990649] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.990658] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.990693] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990702] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990709] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990717] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.990726] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.990734] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990752] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.990768] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.991122] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.991410] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.991696] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.992000] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.992020] [drm:drm_ioctl], pid=4522, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   70.992036] [drm:drm_ioctl], pid=4522, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   70.996422] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.996543] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.996644] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.996737] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.996834] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.996922] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   70.996948] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   70.996987] [drm:drm_vm_open_locked], 0x7fc83be3a000,0x00001000
[   70.996997] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   70.997060] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.997069] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997089] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.997099] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.997108] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.997116] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997124] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   70.997135] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   70.997185] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997195] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997204] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997212] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   70.997221] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   70.997234] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.013795] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.013869] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.013944] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.013954] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014007] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014020] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014029] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014037] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014045] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014057] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.014109] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014119] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014127] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014136] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014145] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014176] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014186] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.014212] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014221] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014228] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014240] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014248] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014299] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014308] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014317] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014326] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014334] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014344] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.014389] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014399] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014407] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014415] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014424] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014438] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014447] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.014470] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014479] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014486] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014494] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.014514] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.014535] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014543] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014557] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014565] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014573] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014581] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014589] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.014598] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.014633] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014642] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014650] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014657] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.014666] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.014674] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.014692] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.014709] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.030637] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.030703] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.030739] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.030761] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.030783] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.030871] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.030880] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.030903] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.030915] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.030924] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.030932] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.030940] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.030951] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.031005] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.031015] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.031057] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.031067] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.031077] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.031091] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.100892] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   71.100924] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   71.100951] [drm:drm_vm_open_locked], 0x7fc83be39000,0x00001000
[   71.100965] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.101031] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101044] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.101081] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101090] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101098] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101133] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101141] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101166] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101177] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101186] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101195] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101204] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101214] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.101264] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101274] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101315] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101324] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101333] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101353] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101362] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.101388] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101396] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101404] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101464] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101876] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101892] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101922] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101938] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101951] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.101962] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.101976] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.101991] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.102057] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102071] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102102] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102115] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.102128] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102185] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.102201] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.102239] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102254] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.102265] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102293] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.102556] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.102569] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.102590] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102599] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.102607] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.102628] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.103876] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.103962] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.103984] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.103998] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104012] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104025] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104124] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104134] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104265] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.104270] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.104273] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104276] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104279] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.104283] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.104298] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104301] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104309] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104312] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104316] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   71.104325] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.104331] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.104387] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104389] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104391] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.104393] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104401] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104405] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104407] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104410] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104412] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.104418] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104882] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.104894] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105086] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105102] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105112] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105120] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105128] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105139] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.105182] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105191] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105221] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105230] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105238] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105258] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105268] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.105295] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105304] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105311] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105320] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105340] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105351] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105361] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105371] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105381] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105416] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105425] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105611] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105626] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105635] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105642] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105651] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105662] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.105698] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105706] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105729] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105739] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105746] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105764] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.105773] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.105799] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105808] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.105815] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.105823] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105843] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105854] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105863] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105874] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.105883] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106118] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.106129] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.106150] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106159] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106167] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106215] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.106224] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.106243] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106251] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106259] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106279] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.106288] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.106305] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106313] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106321] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106338] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.106348] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.106365] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106373] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106382] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106400] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.106409] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.106426] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106434] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106442] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.106471] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106815] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106838] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106849] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106858] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106867] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106875] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106884] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106893] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106902] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106911] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106920] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.106968] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.106977] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107011] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107022] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107030] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107038] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107046] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107056] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107096] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107104] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107131] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107141] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107149] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107176] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107373] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107386] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107414] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107423] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107431] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107466] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107476] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107493] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107502] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107510] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107539] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107549] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107566] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107574] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107582] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107600] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107609] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107626] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107656] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107666] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107690] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.107704] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.107728] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107740] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107753] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.107786] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.107998] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108023] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108036] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108050] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108063] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108076] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.108127] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.108136] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108170] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.108180] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.108190] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.108197] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108206] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.108215] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.108255] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108263] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108289] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108298] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.108305] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.108332] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.771472] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.771494] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771537] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.771555] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.771568] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.771579] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771591] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.771606] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.771676] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771689] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771731] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771746] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.771757] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.771933] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.771950] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.771994] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772007] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772018] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772054] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772065] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772101] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.772115] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.772127] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772137] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772149] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.772163] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.772225] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772238] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772274] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772286] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772297] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772354] [drm:drm_ioctl], pid=4522, cmd=0xc010645b, nr=0x5b, dev 0xe200, auth=1
[   71.772380] [drm:drm_ioctl], pid=4522, cmd=0xc0106464, nr=0x64, dev 0xe200, auth=1
[   71.772402] [drm:drm_vm_open_locked], 0x7fc83be38000,0x00001000
[   71.772415] [drm:drm_ioctl], pid=4522, cmd=0x400c645f, nr=0x5f, dev 0xe200, auth=1
[   71.772480] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.772495] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.772536] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772548] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772559] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.772591] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.772603] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775363] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775397] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.775486] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775504] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.775618] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775636] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.775688] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775700] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.775851] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775864] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.775909] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.775920] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776025] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776036] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776072] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776081] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776099] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776110] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776201] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776212] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776239] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776250] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776375] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776387] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776429] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776440] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776466] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776477] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776574] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776586] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776630] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776641] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776680] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776690] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776783] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776794] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776823] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776833] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776918] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776929] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776961] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.776972] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.776994] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777005] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777032] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777044] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777085] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777102] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777138] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777148] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777175] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777187] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777230] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777241] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777265] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777276] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777307] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777318] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777340] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777372] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777383] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777419] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777430] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777451] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777461] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777479] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777490] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777509] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777539] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777550] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777592] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777604] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777635] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777647] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777790] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777802] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777820] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777831] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777853] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777864] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777880] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777891] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777907] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777918] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777940] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777950] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777966] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.777977] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.777993] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778004] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778025] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778036] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778050] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778062] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778081] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778092] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778108] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778119] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778133] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778144] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778162] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778173] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778188] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778198] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778215] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778227] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778241] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778252] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778269] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778279] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   71.778298] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.778309] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.778319] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.778327] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778336] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.778347] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.778402] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778412] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778528] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778538] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.778546] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778719] [drm:drm_ioctl], pid=4522, cmd=0x4020645d, nr=0x5d, dev 0xe200, auth=1
[   71.778731] [drm:drm_ioctl], pid=4522, cmd=0x40406469, nr=0x69, dev 0xe200, auth=1
[   71.778771] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778781] [drm:drm_ioctl], pid=4522, cmd=0xc0086457, nr=0x57, dev 0xe200, auth=1
[   71.778789] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   71.778907] [drm:drm_ioctl], pid=4522, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   71.778943] [drm:intel_crtc_cursor_set], 
[   71.778947] [drm:intel_crtc_cursor_set], cursor off
[   71.778957] [drm:drm_ioctl], pid=4522, cmd=0xc01c64a3, nr=0xa3, dev 0xe200, auth=1
[   71.778965] [drm:intel_crtc_cursor_set], 
[   71.778969] [drm:intel_crtc_cursor_set], cursor off
[   72.014605] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014622] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014635] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014650] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014715] [drm:drm_ioctl], pid=4522, cmd=0xc01064ab, nr=0xab, dev 0xe200, auth=1
[   72.014726] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014735] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014746] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014766] [drm:drm_ioctl], pid=4522, cmd=0xc04064aa, nr=0xaa, dev 0xe200, auth=1
[   72.014781] [drm:drm_ioctl], pid=4522, cmd=0xc01064ab, nr=0xab, dev 0xe200, auth=1
[   72.014840] [drm:drm_ioctl], pid=4522, cmd=0x641f, nr=0x1f, dev 0xe200, auth=1
[   72.014862] [drm:drm_ioctl], pid=4522, cmd=0xc00464af, nr=0xaf, dev 0xe200, auth=1
[   72.014870] [drm:drm_ioctl], ret = fffffff3
[   72.014915] [drm:drm_vm_close_locked], 0x7fc8365e2000,0x00400000
[   72.014928] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.014967] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.014989] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015005] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015022] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015050] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015080] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015096] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015113] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015129] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015149] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015165] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015184] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015200] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015218] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015234] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015253] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015269] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015308] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015341] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015371] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015400] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015431] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015462] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015493] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015520] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015552] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015577] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015607] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015630] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015656] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015677] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015703] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015724] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015750] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015768] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015789] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015816] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015838] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015863] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015884] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015909] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015932] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.015957] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.015978] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016004] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016033] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016058] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016079] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016104] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016125] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016151] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016177] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016210] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016239] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016270] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016297] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016328] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016355] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016384] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016442] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016471] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016493] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016519] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016541] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016566] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016588] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016613] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016635] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016661] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016683] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016707] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016728] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016754] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016776] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016820] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016842] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016869] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016890] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016915] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016935] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.016961] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.016983] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017008] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017029] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017055] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017075] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017101] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017123] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017148] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017173] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017198] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017215] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017235] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017251] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017273] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017289] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017307] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017323] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017343] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017359] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017378] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017395] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017414] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017430] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017450] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017465] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017486] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017501] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017520] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017536] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017556] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017571] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017590] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017606] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017626] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017642] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017661] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017678] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017697] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017713] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017732] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017754] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017774] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017790] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017809] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017824] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017845] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017860] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017882] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017897] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017917] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017933] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017952] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.017968] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.017988] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018003] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018022] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018038] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018057] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018072] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018092] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018107] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018121] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018133] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018148] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018162] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018170] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018179] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018186] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018234] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018245] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018254] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018263] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018271] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018280] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018289] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018299] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018308] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.018336] [drm:drm_ioctl], pid=4522, cmd=0xc00c6466, nr=0x66, dev 0xe200, auth=1
[   72.018344] [drm:drm_ioctl], pid=4522, cmd=0x40086409, nr=0x09, dev 0xe200, auth=1
[   72.027538] [drm:drm_crtc_helper_set_config], 
[   72.027541] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   72.027546] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   72.027547] [drm:drm_mode_debug_printmodeline], Modeline 30:"1152x864" 0 81620 1152 1216 1336 1520 864 865 868 895 0x0 0x6
[   72.027550] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   72.027553] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.027555] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.027556] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   72.027558] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   72.027564] [drm:drm_crtc_helper_set_mode], [CRTC:3]
[   72.027569] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 0 : v 5 p(0,794)@ 1316161238.129838 -> 1316161238.115609 [e 0 us, 0 rep]
[   72.082620] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.115019] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.115029] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   72.115036] [drm:intel_update_fbc], 
[   72.115039] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.115051] [drm:drm_vblank_get], enabling vblank on crtc 0, ret: -22
[   72.115057] [drm:ironlake_crtc_mode_set], using SSC reference clock of 120 MHz
[   72.115294] [drm:ironlake_crtc_mode_set], Mode for pipe A:
[   72.115298] [drm:drm_mode_debug_printmodeline], Modeline 26:"1600x900" 60 114060 1600 1648 1680 2044 900 902 907 930 0x48 0x9
[   72.115615] [drm] Changing LVDS panel from (-hsync, +vsync) to (+hsync, -vsync)
[   72.170557] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.170578] [drm:intel_pipe_set_base_atomic], Writing base 00063000 00000000 0 0 6400
[   72.170587] [drm:intel_update_fbc], 
[   72.170590] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.226482] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.226491] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.226498] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   72.226506] [drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set [MODE:26:1600x900]
[   72.226513] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.226519] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 7, cursor: 6
[   72.282438] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.338378] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.339187] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   72.339194] [drm:gen6_fdi_link_train], FDI train 1 done.
[   72.339848] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   72.339854] [drm:gen6_fdi_link_train], FDI train 2 done.
[   72.339857] [drm:gen6_fdi_link_train], FDI train done.
[   72.341071] [drm:intel_update_fbc], 
[   72.341074] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.341088] [drm:drm_calc_timestamping_constants], crtc 3: hwmode: htotal 2044, vtotal 930, vdisplay 900
[   72.341095] [drm:drm_calc_timestamping_constants], crtc 3: clock 114060 kHz framedur 16665600 linedur 17920, pixeldur 8
[   72.341106] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[   72.341112] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:5:LVDS-1] set DPMS on
[   72.341120] [drm:drm_crtc_helper_set_config], 
[   72.341123] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   72.341134] [drm:drm_crtc_helper_set_config], modes are different, full mode set
[   72.341138] [drm:drm_mode_debug_printmodeline], Modeline 31:"1152x864" 0 108000 1152 1216 1344 1600 864 865 868 900 0x0 0x5
[   72.341148] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   72.341159] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.341165] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.341170] [drm:drm_crtc_helper_set_config], attempting to set mode from userspace
[   72.341175] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   72.341187] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   72.341197] [drm:drm_calc_vbltimestamp_from_scanoutpos], crtc 1 : v 5 p(0,788)@ 1316161238.443799 -> 1316161238.432125 [e 1 us, 0 rep]
[   72.394303] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.410712] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.410722] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   72.410729] [drm:intel_update_fbc], 
[   72.410732] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.410742] [drm:drm_vblank_get], enabling vblank on crtc 1, ret: -22
[   72.410978] [drm:ironlake_crtc_mode_set], Mode for pipe B:
[   72.410982] [drm:drm_mode_debug_printmodeline], Modeline 27:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x48 0x5
[   72.466242] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.466252] [drm:intel_pipe_set_base_atomic], Writing base 00063000 00000000 0 0 6400
[   72.466260] [drm:intel_update_fbc], 
[   72.466264] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.522182] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.522191] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.522198] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   72.522206] [drm:drm_crtc_helper_set_mode], [ENCODER:13:DAC-13] set [MODE:27:1600x1200]
[   72.522215] [drm:sandybridge_update_wm], FIFO watermarks For pipe A - plane 7, cursor: 6
[   72.522220] [drm:sandybridge_update_wm], FIFO watermarks For pipe B - plane 10, cursor: 6
[   72.578122] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.634048] [drm:intel_wait_for_vblank], vblank wait timed out
[   72.634858] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x100
[   72.634864] [drm:gen6_fdi_link_train], FDI train 1 done.
[   72.635518] [drm:gen6_fdi_link_train], FDI_RX_IIR 0x600
[   72.635524] [drm:gen6_fdi_link_train], FDI train 2 done.
[   72.635527] [drm:gen6_fdi_link_train], FDI train done.
[   72.636741] [drm:intel_update_fbc], 
[   72.636745] [drm:intel_update_fbc], more than one pipe active, disabling compression
[   72.636754] [drm:drm_calc_timestamping_constants], crtc 4: hwmode: htotal 2160, vtotal 1250, vdisplay 1200
[   72.636761] [drm:drm_calc_timestamping_constants], crtc 4: clock 162000 kHz framedur 16666250 linedur 13333, pixeldur 6
[   72.636772] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[   72.636777] [drm:drm_crtc_helper_set_config], 	[CONNECTOR:12:VGA-1] set DPMS on
[   72.636786] [drm:drm_crtc_helper_set_config], 
[   72.636789] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   72.636801] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.636808] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.636813] [drm:drm_crtc_helper_set_config], 
[   72.636816] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   72.636825] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.636831] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.636857] [drm:drm_crtc_helper_set_config], 
[   72.636860] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   72.636868] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.636874] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.636879] [drm:drm_crtc_helper_set_config], 
[   72.636882] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   72.636891] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.636896] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.654277] [drm:drm_crtc_helper_set_config], 
[   72.654281] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   72.654296] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.654301] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.654307] [drm:drm_crtc_helper_set_config], 
[   72.654310] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   72.654319] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.654324] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.675027] [drm:drm_vm_close_locked], 0x7fc83be38000,0x00001000
[   72.675038] [drm:drm_vm_close_locked], 0x7fc83be39000,0x00001000
[   72.675046] [drm:drm_vm_close_locked], 0x7fc83be3a000,0x00001000
[   72.675053] [drm:drm_vm_close_locked], 0x7fc83be3b000,0x00001000
[   72.675061] [drm:drm_vm_close_locked], 0x7fc83be3c000,0x00001000
[   72.675068] [drm:drm_vm_close_locked], 0x7fc83be3d000,0x00001000
[   72.675076] [drm:drm_vm_close_locked], 0x7fc83be3e000,0x00001000
[   72.675083] [drm:drm_vm_close_locked], 0x7fc83be3f000,0x00001000
[   72.675093] [drm:drm_vm_close_locked], 0x7fc83be40000,0x00001000
[   72.675123] [drm:drm_release], open_count = 1
[   72.675131] [drm:drm_release], pid = 4522, device = 0xe200, open_count = 1
[   72.681942] [drm:drm_lastclose], 
[   72.681949] [drm:drm_crtc_helper_set_config], 
[   72.681976] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
[   72.681992] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.681999] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.682006] [drm:drm_crtc_helper_set_config], 
[   72.682010] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:28] #connectors=1 (x y) (0 0)
[   72.682024] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   72.682033] [drm:drm_crtc_helper_set_config], [CONNECTOR:12:VGA-1] to [CRTC:4]
[   72.682043] [drm:drm_lastclose], driver lastclose completed
[   72.682051] [drm:drm_lastclose], lastclose completed
[   78.979312] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xa3f40018, result 1
[   78.979323] [drm:intel_crt_detect], CRT detected via hotplug
[   78.979331] [drm:output_poll_execute], [CONNECTOR:12:VGA-1] status updated from 1 to 1

--0eh6TmSyL6TZE2Uz--
