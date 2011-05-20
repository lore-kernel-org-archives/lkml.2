Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab1ETRGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:06:46 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:51942 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1ETRGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:06:45 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: intel-gfx@lists.freedesktop.org
Subject: Major 2.6.38 regression ignored?
Date: Fri, 20 May 2011 13:06:13 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r4; KDE/4.6.2; x86_64; ; )
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201306.31204.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month ago 
against 2.6.38. Now 2.6.39 was just released without the regression being 
addressed. This bug makes the system unusable... Some guys on IRC suggested I 
email, so here it is.
