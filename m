Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab1LFBmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:42:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:19 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=K_kahUY95AkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=d5jsrEkb_SRr2BbwKTMA:9 a=QEXdDO2ut3YA:10 a=FAmVpxkavJjYFnXEf7AA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014110.079874115@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] [GIT PULL][v3.2] tracing: fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

These are the patches that were also in a tip/perf/core push, but
as they are all bug fixes, we should get them into 3.2.

Thanks,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: ddf6e0e50723b62ac76ed18eb53e9417c6eefba7


Gleb Natapov (1):
      jump_label: jump_label_inc may return before the code is patched

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

Li Zefan (1):
      tracing: Restore system filter behavior

Steven Rostedt (3):
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()
      ftrace: Fix hash record accounting bug

----
 include/linux/ftrace_event.h        |    2 ++
 kernel/jump_label.c                 |    3 ++-
 kernel/trace/ftrace.c               |    5 +++--
 kernel/trace/trace_events.c         |    1 -
 kernel/trace/trace_events_filter.c  |    7 ++++++-
 tools/perf/util/trace-event-parse.c |    2 ++
 6 files changed, 15 insertions(+), 5 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XL1AAoJEIy3vGnGbaoABcUP/idNfxd3BpgHxbi2dBPDhM6y
QVV0v86mMimvnv9PTBJGGKC1q0zYzM+raq56kfwv6cytaFqAbODM//h/f52kuucE
yImR4AtMRekfO3Fz8XovxTIE+idtulL6XPhGMRT9QmPSHw19Ze4Rup7zaLqaCN7x
j3sTtIcu19B+042t/LIC+e4BzOaYnSx6LgPIXzofgx/AZ+lZCgpW1pk9lpwuU0MY
cVx/uzsC7HJRWtpYRluRmbPs1UthWCgEa3JmevrDm22e4ux7VA8Nd6O3GEpEHnjr
Bd6a9Xfgg67HlaaNQYkMaWNmSy1WgFguRjCQa7z/9xwLwLhpsKO4HKAVTVC3kDeT
xrVSuCxDGJAV5yFmUgwjyIrkQprxfMn/GPkQL8vytayutHCOYwKySn38w9u7EApi
ah4EqWBWJqOE0+AI3zXL9A8hFgFspFXPTIGDCVTTbdcVzJMjNZaBclRdiBplRsCU
BlENZwPg1uoWc0I8EnPh199Ha7xu+SVrKiZaJtmRbM2c4RUraBk+DNmB3N4c/DbN
1nD3cZDVBU0vuPjt1rGwRyR7AMGqWOT8YklsP2cRnJmeF/a8tEaZYRLpq8uiHGDQ
W1rNfnQynC6gFeNGaxxwNW8UOG1WQKf/KeKDBo05a7N88x1dZuT9Nw0J17/KlPLc
SI8IF+hJ6H/ormXyG16A
=AJKl
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
