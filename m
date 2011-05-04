Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1EDSOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:14:47 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52754 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:14:46 -0400
Date: Wed, 4 May 2011 20:14:34 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 0/8] xen: Cleanup code/data sections definitions
Message-ID: <20110504181434.GA29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

List of patches:
  - arch/x86/xen/enlighten: Cleanup code/data sections definitions,
  - arch/x86/xen/irq: Cleanup code/data sections definitions,
  - arch/x86/xen/mmu: Cleanup code/data sections definitions,
  - arch/x86/xen/setup: Cleanup code/data sections definitions,
  - arch/x86/xen/smp: Cleanup code/data sections definitions,
  - arch/x86/xen/time: Cleanup code/data sections definitions,
  - arch/x86/xen/xen-ops: Cleanup code/data sections definitions,
  - drivers/xen/sys-hypervisor: Cleanup code/data sections definitions.

Daniel
