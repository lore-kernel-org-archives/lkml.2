Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031286Ab2CNXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:44:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351Ab2CNXoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:44:55 -0400
Date: Thu, 15 Mar 2012 10:44:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20120315104444.13314c47ad2fe62cb43f26d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_10_44_44_+1100_1gUMtAd8Pv+bYtS0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_10_44_44_+1100_1gUMtAd8Pv+bYtS0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (any without
CONFIG_MMU e.g. bfin BF537-STAMP_defconfig) failed like this:

fs/proc/task_nommu.c:173: undefined reference to `vm_is_stack'

Caused by commit "procfs: mark thread stack correctly in proc/<pid>/maps"
from the akpm tree which only defines that function when CONFIG_MMU is
set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_10_44_44_+1100_1gUMtAd8Pv+bYtS0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYS1sAAoJEECxmPOUX5FEh/UP/0wXtfkj0MtBkw3MIdsFLzLN
/D2hy3r0tJy6t7TUj2v7Q1qajNwDXlm52E/M+aD250MvfuWXOfyI/42paneXIWwC
XkYhX6USXwlYj/NXkxFpvFwm7DeKtC6aUK/lGoQBVYabfaX/fT/NoFaX5oUqPsV2
t5INR2d9mqyOK+6xDkszLICegIbt2DDy1Qqd48TGxC5a2hMMkd1O3mep3gCfvBzJ
XC14mSsz3/EpDO1AXz+EpavBPzDLa6bsPSFep+ED8I08cCX97SU4pK7mTwD0/n+H
dwbiUvFLiEuHqluHnPvhtbNRtDDm6GnFmalTWqtry0EtPV+NMAcDdXghGgB0HAOs
bwRTKMK5P10bv9hJzzbjbSuGc1K6e8I6MidQQpPeD1eZRuAsLbfO+LvRvIZ4KgHt
47E8k8QhYX42p9JK25YLTuOT1w8URscdJ9XQFEBlvzJGhl0F6CX/2RgAmMHYJmQi
K6j0BvXvkTUOGIsaRN6PQXcR7DfddlRJFu/fhWJxgoc8sv7ZM67bi7xVQLS4smpa
Iwt9gxIMZio5e6CF+xmsU7OGkISBXAZwVhjA9K2AkTAGaG6Oprfr+Qk69k64Hen5
ZZ4yGqaCXzq9OdeFFOhuQJOka+z4VJB2+8nnYRXFlsO1YI0gsvHNQRT/2awv36TD
pabrEd9P3gutlD10OKku
=g667
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_10_44_44_+1100_1gUMtAd8Pv+bYtS0--
