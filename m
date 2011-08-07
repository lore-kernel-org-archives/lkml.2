Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1HGWaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 18:30:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1HGWaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 18:30:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Mandeep Singh Baines" <msb@chromium.org>
Subject: [Regression] Boot crash caused by commit 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
Date: Mon, 8 Aug 2011 00:31:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108080031.26165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Unfortuately, your commit 1eb19a12bd2214cdcad5273d472b062a4ba97fa1
(lib/sha1: use the git implementation of SHA-1) causes one of my test
systems, which is an ARM shmobile Mackerel development boards, to crash
during boot (due to referencing invalid addresses AFAICS).

Please fix or revert.

Thanks,
Rafael
