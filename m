Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1KRCOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 21:14:00 -0500
Received: from home.keithp.com ([63.227.221.253]:43234 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab1KRCOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 21:14:00 -0500
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hook up Ivybridge eDP
In-Reply-To: <1321569940.18123.7.camel@atropine>
References: <1321489780-17085-1-git-send-email-keithp@keithp.com> <1321569940.18123.7.camel@atropine>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 17 Nov 2011 18:13:56 -0800
Message-ID: <yun8vnech3v.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 17:45:40 -0500, Adam Jackson <ajax@redhat.com> wrote:

> Your silicon people worry me.

In any case, the changes are mostly to move bits around so that there
are two bits for pipe select

> I don't even.  Unless you're looking at some other version of the DP
> spec than me, I was pretty sure those weren't legal voltage values.  And
> 3.5dB preemph on 1000mV gives you 1500mV at the peak, which is
> definitely outside the spec.

I'm just writing down what's in the spec. I don't use these values, just
the useful ones above.

You don't happen to have any hardware to test this with, do you?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsW/ZDYtFsjWk68qAQiTIxAAvHI5yXadLLqasImSPJ8cj9S0wrFNGCZS
NDLj+wc0ns5wf857bSag7Cs6eoBQ3tM4PLy6i/KUGMoxiRKkU7Ile/vRkUvOIe/4
xaGhe3zBx2AHY8B/QsrscJyyZ5XtQpgSaSUhAU1BofwfEwGk5wNtBCifW3nUpnh7
KJSpmd/k9wghHM/Gdehhti3BVU394YySJIqNkE/AveWUd4kXQjvRcJy+bDieDj5t
Q4728T/NeYgk1aYiDb30osCibcOASylfyPyqUvr3m/+gIjSojGYOeWrKvCxoqgsG
509Ii3nTYHDVsjulXGzvMc5ohLm2pv/fErxlrxXWNF4ah0VLvSC8XnkB81FsNq86
rodJQvbmuxYYc3tCxXxwb2PX1tnhan8whcNa9XOw43rUj+xv/F7dSOkDw4s2lLLL
J1yBi5ooULM2t8BTRGPkfE8mo9raW3u3J04nCJqgor4ZpHNYnk3eMHH/AJcdaVEG
ijYesXWHEjVFUpytLaj+h2RnSlLmaK6wj28gP0H5ohd+8g+F7APGMisQVoiqc6Ln
bMTCGDWeMKE5xsj4lN6odtSc35sAcqL5JRxGUM8YI3kEM5Eq3iyBMfBLGNOQ4i8n
RZw2wAmndambJkIc+HRhZcm7TIX/zGClnxD2+UkJ8piu/Qat4VA9IKz9pVKSZldG
PjwaSRcgKo0=
=MEgM
-----END PGP SIGNATURE-----
--=-=-=--
