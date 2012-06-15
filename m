Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2FOBDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:03:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2FOBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:03:39 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=76z5FlY3WM0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=f2o29hxsxEOxOyM2U7AA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=0hJLlp-nx6MoPAkpMtwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120615010337.907377904@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Jun 2012 21:01:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] tracing: Add comments for the other bits of ftrace_event_call.flags
References: <20120615010123.722084844@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Add-comments-for-the-other-bits-of-ftrace_ev.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

	TRACE_EVENT_FL_ENABLED_BIT,
	TRACE_EVENT_FL_FILTERED_BIT,
	TRACE_EVENT_FL_RECORDED_CMD_BIT,

Have comments about what they are, but:

	TRACE_EVENT_FL_CAP_ANY_BIT,
	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,

do not, making them second class citizens. To prevent another
class warfare, these bits have protested for their right to be
commented. And By Golly! I'll give them what they want!

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 176a939..1aff183 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -207,6 +207,9 @@ struct ftrace_event_call {
 	 *   bit 1:		enabled
 	 *   bit 2:		filter_active
 	 *   bit 3:		enabled cmd record
+	 *   bit 4:		allow trace by non root (cap any)
+	 *   bit 5:		failed to apply filter
+	 *   bit 6:		ftrace internal event (do not enable)
 	 *
 	 * Changes to flags must hold the event_mutex.
 	 *
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP2onpAAoJEIy3vGnGbaoA2nkQAOQ8ULgFRsEHBGxT1ZnkCVov
T5NPN0h1dpU/uVXqIHluLCO6oOjObIg/5/pSqCtfbHdz34lkT9wLK28o29556iPd
RVli+BAINU21NBX1bLaocz/5GshMSy16pD7MtIt8WEA8d6DG4OQc96kYbs+1ZQ3A
TLSrEz9QZlXUAFh+9pnvlAEWRPzf4QZ/gdW70FZjBZR1bCxUL1L1E/5zTDLC+2l1
77ZWgjgnseMJmeHuTkQLKhNCElaFq/YX1mPKDpIai48v/hEvyyBexb04Ac1EhPyd
ABifQAEviexEb2PL5zc1FinhVBUfIzO5FaxVVw9eTKtRGh1gqcl3AO22vXJW1tLE
lTG6foo5lda9YAatTG6dPojIYK9kHrJsa+pBmrwNT5jYqKBOe2rpTd3S7Cu6Vhsu
3aISDHut1MRtCy7t3fJaiaqbJmlgK9E4c0Qv2B1/79LARYJsFuQHfNazcqw42Gfq
QuMmiyhzoo3cAEItzLAORA/IPQhAep15IwcrsSMlPSn7F6oHMYqG5DvhrQXze2zV
Eq6DgMt/SPVaVrWIqG5coRv0Oq3YkRl19tuXhapriD+I+j6AVOZWg5yV9bkySapi
9gqG6/W6oJHH2+mlFTiTQgC02FuwtmZOEFf7Wfz2D7Tuk11VeGT9Hd7q6XtRXIza
qG1TUaKOH+LyiQdUmE+Z
=KyhO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
