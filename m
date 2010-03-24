Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0CXF7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:59:09 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:11591 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0CXF7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:59:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: How to reserved all the CPU time for the private computing
Date: Wed, 24 Mar 2010 13:58:47 +0800
Message-ID: <2234BBB33B4B2048B28E3B3ACFC9795C01B834EB@CNBEEXC007.nsn-intra.net>
In-Reply-To: <20100324054227.GB9336@spritzerA.linux.bs1.fc.nec.co.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to reserved all the CPU time for the private computing
Thread-Index: AcrLFSlcQDd/71I0TEK/qFdUx3SCkAAACeUg
References: <20100324054227.GB9336@spritzerA.linux.bs1.fc.nec.co.jp>
From: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
To: "LKML" <linux-kernel@vger.kernel.org>, <linux-arch-owner@vger.kernel.org>
X-OriginalArrivalTime: 24 Mar 2010 05:59:04.0035 (UTC) FILETIME=[1B8C5B30:01CACB17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

Thank you very much firstly.
I have send the similar questions last time and I also search solutions
in the internet.

Scenario:
multi-core cpu, but only one of cores is running linux for control
plane, while others are running the private 100% computing

Solution:
The following steps are done:
1. Add the isolcpus opinion in the kernel command
2. The init thread only can run in the control CPU
3. disable all the local interrupt in the other CPUs/cores.

Result:
The system can be up, but NOT stable. Any system call may stuck the
shell(i.e  ping/chkconfig ). 

Question:
Could some give me some help/suggestion for the next steps?

Thanks a lot.
