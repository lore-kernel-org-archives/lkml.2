Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2BMItZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:49:25 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:59292 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2BMItY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:49:24 -0500
From: Mikael Starvik <mikael.starvik@axis.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Feb 2012 09:49:22 +0100
Subject: SMP MIPS and Linux 3.2
Thread-Topic: SMP MIPS and Linux 3.2
Thread-Index: AczqLFmamPTuvzDTTIubWZgAhAn6UA==
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D055C767F6C48@xmail3.se.axis.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running Linux 3.2 on a MIPS 34K with two VPEs (in MT_SMP configuration). It works fine in UP but with SMP it deadlocks during bootup (both CPUs gets idle). Typically like this:

[    0.090000] CPU revision is: 01019550 (MIPS 34Kc)
[    0.090000] Primary instruction cache 32kB, VIPT, 4-way, linesize 32 bytes.
[    0.090000] Primary data cache 32kB, 4-way, PIPT, no aliases, linesize 32 bytes
[    0.170000] Brought up 2 CPUs
<No more output>

I have tried to enable __ARCH_WANT_INTERRUPTS_ON_CTXSW but that didn't improve anything. Anyone else got this running or have any thoughts about what the problem may be?

Best Regards
/Mikael
