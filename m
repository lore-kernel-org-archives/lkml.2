Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2EEGIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:08:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59703 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2EEGIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:08:31 -0400
Date: Sat, 5 May 2012 16:08:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com
Subject: Re: [PATCH 3/3] dynamic_debug: remove unneeded includes
Message-Id: <20120505160817.4cfa6a5c3cd2547e13e1d70b@canb.auug.org.au>
In-Reply-To: <CAJfuBxzy224rg9No5L281gkp369ZfTjqADpeoxysvL5oNDk-Ng@mail.gmail.com>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
	<1336067860-19953-3-git-send-email-jim.cromie@gmail.com>
	<20120505143629.57126695eba8787d1033ac7b@canb.auug.org.au>
	<CAJfuBxzy224rg9No5L281gkp369ZfTjqADpeoxysvL5oNDk-Ng@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__5_May_2012_16_08_17_+1000_ZFmh/teuUFDEmQmJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_May_2012_16_08_17_+1000_ZFmh/teuUFDEmQmJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jim,

On Fri, 4 May 2012 23:52:24 -0600 Jim Cromie <jim.cromie@gmail.com> wrote:
>
> compiled on Core, and boot tested on i586
> also recently compiled on x86_64

Yeah, the problem being that we have 27 architectures. a large number of
platforms and en enormous number of CONFIG variables and all of these
things can affect whet gets implicitly included.

> I guess I better make lib/dynamic_debug.i
> inspect the file, and possibly revert parts of this patch.

I am not sure that would help much (see above).  Also note Rule 1 from
Documentation/SubmitChecklist :-)

> BTW, how were you carrying that merge conflict resolution ?
> git rerere ?

Yep.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_May_2012_16_08_17_+1000_ZFmh/teuUFDEmQmJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpMPRAAoJEECxmPOUX5FE9sQQAJ32CYAWSrgZK89mwwzPiePD
P7/y9laGHfE9xquvJpXHfz8jtvvIZeM7865Mn1CMCh+eNknbhZuy/Jj3r8xHjw1L
ZtnA04SHq8nmAIoj3r61AlRAUw3fxrbiytnyyoDkS6rOGHbRSvDhEgQEgQKne7CA
45BUIjfPsCbC1Zy+vGrzIImFZLLO1a9bfyF4Ez55UeXjo8TN8gMdXYyX8vbfTvbJ
ih1BTwVs6JBP3tUnQD6x3vInNE4Eure/HiS6Vyrwfqv+DytMDia4sNeKyOEQcJY0
IZ/ehV3PpkMF9sgF8fhNcRVXt4iufSZG5EkO5949eLeNzNaMthS6jlHbyQRt4wU9
ThokBQwhnRYbpECRrsq4BK9LSnzHZqtmRdqYzIXP4FB2iCkNHyKp63kaZZVcMB+S
7bte7lsOFZze+Mwi+DBawRW5C0obsQUd+phLnU3iQPoR91m3ldQIz2yhgIhZk6CT
2YsHtCv3DFnjVKAm9HWW1lPaDR0vKy+jQrSPmu46NCA4nRdRSMgUEgfP7q4yL88a
RAtjsZ7ruQtwkPFqby9RrbxSLQ0PiVF36EYgJL3hSaY/z18xcmiUilf4akxsJyTq
ml+OOTClbG1QquN3MCYjUUnc+MAC24gfswNKpk6gVrQk0uAYU/N0brUcreV+4oSG
qTX8mUkKyCJZQRwB3L6X
=oE/v
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_16_08_17_+1000_ZFmh/teuUFDEmQmJ--
