Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0CQLAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:00:32 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:35711 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251Ab0CQLAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:00:31 -0400
Subject: checkpatch false positive
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 11:00:29 +0000
Message-ID: <1268823629.1999.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this error from checkpatch which is a false positive AFAICT.
I don't see any other way to code this macro so maybe this rule
shouldn't apply?.

	ERROR: space prohibited before open square bracket '['
	#24: FILE: drivers/staging/wlan-ng/p80211wext.c:1685:
	+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]

regards
Richard

