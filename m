Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1G0M6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:58:19 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50212 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1G0M6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:58:15 -0400
Message-Id: <20110727125504.491183728@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 27 Jul 2011 14:55:04 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v2 00/10] kdump: Patch series for s390 support (version 2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

To make progress and for getting at least the "standard" kdump port upstream
soon, I send you now the updated patch series that contain the s390 kdump port
without stand-alone dump support. The support for stand-alone dump tools
can be added later.

Main changes compared to version 1:
1. We use purgatory code
2. We use pre-allocated ELF core header
3. Registers are saved in old kernel
4. Removed meminfo

The following patches are most interesting for you:
[1-4] Common code changes
[9]   S390 kdump kernel backend
[10]  S390 kdump kexec-tools backend

Patches 5-8 are s390 specific preparation patches for the kdump port.

I hope we will make progress.
Thanks!

Michael
