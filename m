Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2DAJ4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 05:56:54 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:15845
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab2DAJ4x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 05:56:53 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1SOYN-01-134-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>
Subject: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKdw==
Date: Sun, 1 Apr 2012 09:56:44 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/mutex-design.txt:

"- 'struct mutex' is smaller on most architectures: E.g. on x86,
   'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
   A smaller structure size means less RAM footprint, and better
   CPU-cache utilization."
================================================================
Now in my x86-64 32-bit Linux environment, 'struct semaphone' is 16 bytes,
'struct mutex' is 20 bytes. So seems the RAM footprint advantages are not there...

For the performance advantages followed, I don't have the ./test-mutex and maybe the 
testing environment, so haven't the 1st hand data for this item...




