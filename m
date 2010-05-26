Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0EZVQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:16:49 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:36216 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0EZVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:16:48 -0400
From: Eric Anholt <eric@anholt.net>
To: Dan Carpenter <error27@gmail.com>, David Airlie <airlied@linux.ie>
Cc: Zhao Yakui <yakui.zhao@intel.com>, Ma Ling <ling.ma@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Keith Packard <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] i915/intel_sdvo: remove unneeded null check
In-Reply-To: <20100507084009.GZ27064@bicker>
References: <20100507084009.GZ27064@bicker>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 26 May 2010 14:16:44 -0700
Message-ID: <87bpc2l5xf.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Fri, 7 May 2010 10:40:09 +0200, Dan Carpenter <error27@gmail.com> wrote:
> The "connector" variable is used as the cursor in a
> list_for_each_entry() and it's always non-null so we don't need to check
> it.

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9j7wACgkQHUdvYGzw6vfSTgCdG5PoOYLSQXHtkQAMQA+72xLN
RKAAn3nghcyDMv6M0bwhRleTACcPi86g
=dw7x
-----END PGP SIGNATURE-----
--=-=-=--
