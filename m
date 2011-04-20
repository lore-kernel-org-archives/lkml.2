Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1DTN5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:57:17 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:8676 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab1DTN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:57:16 -0400
X-IronPort-AV: E=Sophos;i="4.64,246,1301868000"; 
   d="scan'208";a="93502821"
Date: Wed, 20 Apr 2011 15:57:12 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: non-linux fixup [was: util-linux v2.19.1-rc1]
Message-ID: <20110420135712.GS7529@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org
References: <20110420121951.GB29492@nb.net.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20110420121951.GB29492@nb.net.home>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Could you apply the attached trivial fixup?

Samuel

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/configure.ac b/configure.ac
index 68f0abf..eaab8aa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -859,7 +859,7 @@ build_lsblk=yes
 if test "x$have_openat" = xno; then
   AC_MSG_WARN([openat() function not found; do not build lsblk])
   build_lsblk=no
-elif test "x$have_linux" = xno; then
+elif test "x$linux_os" = xno; then
   AC_MSG_WARN([non-linux system; do not build lsblk])
   build_lsblk=no
 fi

--gBBFr7Ir9EOA20Yy--
