Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2JQIjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:39:03 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:16802 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2JQIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:39:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,599,1344211200"; 
   d="scan'208";a="15218942"
Message-ID: <1350463138.2460.19.camel@zakaz.uk.xensource.com>
Subject: [PATCH 00/10] xen: build fixes and interface tweaks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 09:38:58 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is based on v3.7-rc1 and fixes various build fallout which
I discovered when build for Xen on ARM.

It also cleans up a final few s/unsigned long/xen_{pfn,ulong}_t/
changes. These have no impact on x86 (since those types are typedefs of
unsigned long) but change the ARM port to use the interface we have
settled on and which I shall be committing to the h/v shortly.

I've sent a few of these out individually as I've gone along too, but
they are mostly independent so I figure there's no harm in resending.

Ian.

