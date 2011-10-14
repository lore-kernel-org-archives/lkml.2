Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1JNNqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:46:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64215 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JNNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:46:49 -0400
Message-ID: <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: RE: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Seger, Mark" <mark.seger@hp.com>
Cc: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 15:47:03 +0200
In-Reply-To: <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
	 <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 14:36 +0100, Seger, Mark a écrit :

> For me the easiest reproducer, which admittedly doesn't show any
> deeper analysis, is to just run "cat /proc/stat>/dev/null" in a loop
> and time it.

OK, but you already provided a global number.

We would like to check where in kernel cpu time is consumed.
Maybe something really obvious could pop out.

"perf" is provided in kernel sources, and really is a piece of cake.

cd tools/perf ; make 



2x4x2 means : Two sockets, 4 cores per physical package, 2 threads per
core.



