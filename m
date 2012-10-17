Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2JQLcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:32:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48416 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JQLcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:32:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344211200"; 
   d="scan'208";a="15223926"
Message-ID: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
Subject: [PATCH V2 0/6] arm: implement ballooning and privcmd foreign
 mappings based on x86 PVH
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        xen-devel <xen-devel@lists.xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 12:31:58 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is much reduced after rebasing onto V2 of the X86 PVH
patches, thanks Mukesh.

The baseline is v3.7-rc1 + "xen: build fixes and interface
tweaks" (posted this morning) and the PVH V2 patches from Mukesh.

With this series I can build a guest on Xen ARM.

The final patch requires that XENMEM_add_to_physmap_range be implemented
for x86 on the hypervisor side. For inspiration the ARM version can be
found at <1350314444-17148-1-git-send-email-ian.campbell@citrix.com>
(and will likely be in xen-unstable soon).

Ian.

