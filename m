Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737Ab2JXNTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:19:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53825 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934678Ab2JXNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:19:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15358978"
Message-ID: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
Subject: [PATCH+GIT V3 0/5] arm: implement ballooning and privcmd foreign
 mappings based on x86 PVH
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Date: Wed, 24 Oct 2012 14:19:16 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is rebased onto 0e9e3e306c7e (AKA current Linus, which now includes
the previously prerequisite series "xen: build fixes and interface
tweaks") and Konrad's stable/pvh.v5 branch.

For convenience I've also pushed to 
        git://xenbits.xen.org/people/ianc/linux.git
        arm-privcmd-on-x86-pvh5
Note that this contains my merge of Konrad's branch into Linus' tree at
the base. You might want to cherry pick it rather than merge it.

Ian.

