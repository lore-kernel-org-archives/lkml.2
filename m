Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1LVFdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:33:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52143 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1LVFdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:33:15 -0500
Date: Thu, 22 Dec 2011 16:33:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build warnings after merge of the final tree
Message-Id: <20111222163304.26be6d0f5e514fefb078c0a6@canb.auug.org.au>
In-Reply-To: <4EE8D305.8020407@zytor.com>
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
	<1323880322.23971.33.camel@gandalf.stny.rr.com>
	<4EE8D305.8020407@zytor.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_16_33_04_+1100_t4Tvbnz4kJCvcKst"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_16_33_04_+1100_t4Tvbnz4kJCvcKst
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Wed, 14 Dec 2011 08:47:01 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 12/14/2011 08:32 AM, Steven Rostedt wrote:
> > On Wed, 2011-12-14 at 18:15 +1100, Stephen Rothwell wrote:
> >=20
> >> Maybe caused by commit d5e553d6e0a4 ("trace: Include <asm/asm-offsets.=
h>
> >> in trace_syscalls.c") from the tip tree.  These warnings may have been
> >> here for a while as it is hard to catch the new ones among the flood.
> >>
> >=20
> > hpa,
> >=20
> > Was this change only needed for x86? If so, could you put that into
> > asm/ftrace.h instead?
> >=20
>=20
> Yes (on both accounts).  It was part of the syscall changes; I'll move
> the include.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Dec_2011_16_33_04_+1100_t4Tvbnz4kJCvcKst
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8sEQAAoJEECxmPOUX5FEV/oP/iI+sI2uZzvXPxhT907a/jCa
WNrIlfq/NWLFUaQ6km62qXiPkkSTLNDwlM+YWABXkf45SLR/oOVLntH673DV216P
nSOms0qvfTifHpYF0yQRN43s8isL3PoxQKtbsPErhA5A1xjgOBO/SFlG26WlHZKd
pKwkFLjkywRgrnLdKLh7rk6cApncL7Qv3I4kcrsOGtLLSnF6lDPuovMrVdalScEq
ZyO68ZPfj1JQNqNd2MSwPSnKRpcmb499BKZExC/0GRrxUH1iLK3MGoRc85WzQbHd
7fLSyj2bSx0qhC+L1Z3TpKwR8VIuAB6Q9c7FEaz4vjdG+WdTqq/YiQdxadGxnWGz
MqBqYmkhn0lKy3kWol37KCBfx6E8T3skc+yIDvDINUL+7FXrMsE9MO/9rzQMsWK1
JQuSO/rU0tx1uNk0aYNBGxOaSLFwcT0Uw4qyoBy5q//8X2EyjgbAlKCDchoDv37L
A6c99AyXXnxFIgbMvzuFU4PwUD5WwsB3EOr3vLHdnd9CbAMYlDOMq+X5xuAG+vqs
BXcDEVPkL8LQ5R+W557Z0cTmgwVm3NWj30f9S9h2yvl7ZhzuPagkbYL/p2FeekZY
/UoZLSs9WcgSd7E5DvzpKhiDF1kxP6FnNFhwjIhwNTZopNOpu2/PvZiP9MpmFtzi
J4llKVp8xALM40bAn2tG
=R18X
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_16_33_04_+1100_t4Tvbnz4kJCvcKst--
