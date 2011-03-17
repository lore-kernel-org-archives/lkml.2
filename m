Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1CQVrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:47:52 -0400
Received: from que02.suddenlink.net ([208.180.40.87]:57944 "EHLO
	que02.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1CQVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:47:49 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 17:47:49 EDT
From: Curt Howland <Howland@priss.com>
Organization: Acolytes of the Goddess Priss
To: linux-kernel@vger.kernel.org
Subject: Compile error: arch/x86/kernel/entry_32.S:1422: Error: .size expression does not evaluate to a constant
Date: Thu, 17 Mar 2011 17:41:39 -0400
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103171741.39876.Howland@priss.com>
X-Cloudmark-Analysis: v=1.1 cv=1ySWNNja79c/jgOHmXRKbmV/BjW144TMdFddqTN+fW0= c=1 sm=0 a=BeJfjmuleZIA:10 a=ejar3VpVzU4A:10 a=kj9zAlcOel0A:10 a=YgUFFZ79AAAA:8 a=GQzCuT0m0PncxsiD-JkA:9 a=IiV9v4vQ8Y8Ci2ounkRw9JtqDlUA:4 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


2.6.38-rc6 compiled just fine, 2.6.38-rc7, -rc8 and the released 
2.6.38 all got this error, with gcc 4.4 and after Debian Unstable 
updated to gcc 4.5:

arch/x86/kernel/entry_32.S: Assembler messages: 
arch/x86/kernel/entry_32.S:1422: Error: .size expression does not 
evaluate to a constant make[3]: *** [arch/x86/kernel/entry_32.o] 
Error 1

I searched for this error and saw this had been posted to the LKML:

http://www.gossamer-threads.com/lists/linux/kernel/1347760

This was when the error happened in -rc7, but it was not fixed 
for -rc8 or the released stable.

I'm just a user, not a developer, but I figure if its happening to me 
with very generic tools it may be happening to other people who don't 
use git, who don't apply patches, and such.

I don't have the warewithall to subscribe to the LKML, so I would be 
obliged if you would copy me on any replies. I would be glad to 
supply any further information if needed.

Curt-

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTYKAEy9Y35yItIgBAQKijQf9EMM/9GhAc8q20ANAfiNmWFjkxNLGmpMr
oTg0pTs07YHF/TNmbTH65OP4nI7uLTEKBD+LLZ0xy5GIqEdFi0rjLKf1SIp0qLbu
4jWicMrhd4gN/FijJl/BoYEJ+LiRYNtZcySVr1p9TCmh0IBsWbMpM05sxBCvHBIg
EzMKhYHIQ/h24gsTpLqrWE2pv/BjFofzb6rzNkAuzG6PVlcBsdbRjBDhTriQgZeO
krtOMPQHGX3ZMYkpNqIwHvf6nVlVUhMQlOLs/Uuii//N2Rke38/a35NN+XlywcC7
bok2n0frIMxoaYzGezGlFXRYpjImRe9DrmlOr4xeiafFkBNaLLMxFw==
=VOjl
-----END PGP SIGNATURE-----
