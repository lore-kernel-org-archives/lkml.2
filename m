Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1G2MkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:40:25 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43060 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1G2MkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:40:21 -0400
Message-Id: <20110729123944.562622201@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 29 Jul 2011 14:39:44 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/3] kdump: Add external kdump entry point for s390 stand-alone dump tools
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

I finished the patches that add the stand-alone dump tools support on
top of the recently sent v2 patch series. The following three patches
implement the program check idea that we have discussed recently:

[1] kdump: Add new machine_kexec_finish() architecture callback
[2] s390: Add external kdump entry point for s390 stand-alone dump tools
[3] kexec-tools: Emit program check on s390 for checksum failure

Thanks!

Michael
