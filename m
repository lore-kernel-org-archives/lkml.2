Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1C0UqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:46:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1C0UqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:46:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alexander Beregalov" <a.beregalov@gmail.com>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
In-Reply-To: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <40UNry85rJN.A.wxE.Jo5jNB@chimera>
Subject: [Bug #29852] 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 27 Mar 2011 22:27:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29852
Subject		: 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2011-02-21 20:33 (35 days old)
Message-ID	: <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
References	: http://marc.info/?l=linux-netdev&m=129832042402668&w=2


